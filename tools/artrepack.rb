#!/usr/bin/env ruby

def main
  Dir.glob("src/data/*.art????").sort.each do |fname|
    repack fname
  end
end

def repack(in_fname)
  data = read_binary_file(in_fname)
  (refs_offs, lits_offs, row_count,) = data[2..][...6].unpack("S<"*3)
  masks_offs = 0x0008
  raise "weird header order" unless masks_offs < refs_offs and refs_offs < lits_offs
  masks = data.bytes[masks_offs...refs_offs]
  refs = data.bytes[refs_offs...lits_offs]
  lits = data.bytes[lits_offs...]
  raise "literals table truncated" unless lits.length % 4 == 0

  # Unpack
  # Masks are LSbit-first
  li = 0
  ri = 0
  planebytes = (0...row_count).map do |i|
    if ((masks[i>>3]>>(i&0x7)) & 0b1) == 0
      # Literal
      li += 1
      lits[(li-1)*4...li*4]
    else
      # Reference
      r = refs[ri]
      ri += 1
      if r >= 0xF0
        r = (r&0x0F) + refs[ri]
        ri += 1
      end
      lits[r*4...(r+1)*4]
    end
  end.flatten

  # Compute savings if we were to do this fully unmasked and just use an offset table
  # (spoiler: the masks actually save space)
  saving_if_unmasked = row_count/8
  (0...(lits.length/4)).each do |i|
    saving_if_unmasked -= (i < 0xF0 ? 1 : 2)
  end

  # Report
  puts format("%-50s %5d rows=%4d lits=%4d refs=%4d saving_if_unmasked=%+6d", in_fname, data.length, row_count, lits.length/4, refs.length, saving_if_unmasked)
  planetiles = each_tile(planebytes) { |tile| tile }
  case_check("Simple case", planebytes)
  case_check("Cross-row", rel_xor_diff(planebytes, 4))
  case_check("Cross-row separate", each_tile(planebytes) do |tile|
    rel_xor_diff(tile, 4)
  end.flatten)
  case_check("Optional repeat", rel_xor_diff_optimistic(planebytes, 4))
  if false
    # Currently fares worse, and optimising seems to make it *even worse*?
    reordered_bytes = optimise_tile_order(planetiles).flatten
    case_check("Cross-tile optimised", rel_xor_diff(reordered_bytes, 64))
    case_check("Cross-tile", rel_xor_diff(planebytes, 64))
    case_check("Cross-row+tile", rel_xor_diff(rel_xor_diff(planebytes, 4), 64))
  end

  #case_check("Cross-2row", rel_xor_diff(planebytes, 16))
  #case_check("Cross-2row separate", each_tile(planebytes) do |tile|
  #  rel_xor_diff(tile, 16)
  #end.flatten)
  #case_check("Cross-plane", rel_xor_diff(planebytes, 1))

  puts ""
end

def optimise_tile_order(in_tiles)
  # Do this the greedy way for now.
  rem_tiles = in_tiles.map {|tile| tile}
  out_tiles = [rem_tiles.shift]

  until rem_tiles.empty?
    tp = out_tiles[-1]
    rem_tiles.sort! do |tn|
      (0...16).filter { |i| tp[4*i...4*(i+1)] != tn[4*i...4*(i+1)] }.length
    end
    #tn = rem_tiles[0]
    #p [(0...16).filter { |i| tp[4*i...4*(i+1)] != tn[4*i...4*(i+1)] }.length, rem_tiles[0]]
    out_tiles.append rem_tiles.shift
  end

  out_tiles
end

def case_check(desc, planebytes)
  uniq = Set.new
  nonzero = 0
  raise "non-integral number of rows" unless planebytes.length % 4 == 0
  planerows = (0...planebytes.length/4).map {|i| planebytes[4*i...4*(i+1)]}
  planerows.each do |r|
    uniq.add r
    nonzero += 1 if r.sum == 0
  end
  puts format(" - %-22s zero=%4d/%4d uniq=%4d", desc+":", nonzero, planerows.length, uniq.length)
end

def rel_xor_diff(planebytes, delta)
  planebytes[0...delta] + (planebytes[delta...].zip(planebytes).map { |(vnext, vprev)|
    vnext ^ vprev
  })
end

def rel_xor_diff_optimistic(planebytes, delta)
  xorbytes = rel_xor_diff(planebytes, delta)
  planerows = (0...planebytes.length/4).map {|i| planebytes[4*i...4*(i+1)]}
  xorrows = (0...xorbytes.length/4).map {|i| xorbytes[4*i...4*(i+1)]}
  planerows.zip(xorrows).map { |(p,x)| x.sum == 0 ? x : p }.flatten
end

def each_tile(planebytes)
  raise "non-integral number of tiles" unless planebytes.length % 64 == 0
  (0...(planebytes.length/64)).map { |i|
    yield planebytes[i*64...(i+1)*64]
  }
end

def read_binary_file(fname)
  # File.read() is borked. Use something that doesn't ruin file contents.
  File.open(fname, "rb") { |fp| fp.read }
end

main
