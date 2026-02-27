class LayoutSpec
  attr_reader :name, :fname
  def initialize(name:, fname:)
    @name = name
    @fname = fname
  end

  def self.[](**)
    new(**)
  end

  def unpacked_2d
    unless @unpacked_2d
      rle_data = File.read(fname)
      $total_rle_bytes += rle_data.length
      unpacked_1d = unpack_rle_1d(rle_data)
      assert unpacked_1d.length % width_mt == 0
      @unpacked_2d = (0...height_mt).map do |y|
        (0...width_mt).map do |x|
          unpacked_1d[x+(y*width_mt)]
        end
      end
    end
    @unpacked_2d
  end

  def each_chunk(chunk_size)
    assert width_mt % chunk_size == 0
    assert height_mt % chunk_size == 0
    (height_mt/chunk_size).times do |cy|
      (width_mt/chunk_size).times do |cx|
        unc_chunk = extract_chunk_data_from_2d(cx*chunk_size, cy*chunk_size, chunk_size, chunk_size)
        yield cx, cy, Chunk.new(uncompressed_1d: unc_chunk)
      end
    end
  end

  def extract_chunk_data_from_2d(x0, y0, lx, ly)
    data = unpacked_2d()
    (0...ly).map do |sy|
      (0...lx).map do |sx|
        data[y0+sy][x0+sx]
      end
    end.flatten
  end

  def width_mt
    1 << fname[-1].to_i
  end

  def height_mt
    4096 / width_mt
  end
end

class Chunk
  attr_reader :uncompressed_1d
  include Comparable

  def initialize(uncompressed_1d:)
    @uncompressed_1d = uncompressed_1d
  end
  def <=>(other)
    @uncompressed_1d <=> other.uncompressed_1d
  end
  def eql?(other)
    @uncompressed_1d.eql? other.uncompressed_1d
  end
  def hash
    [@uncompressed_1d].hash
  end

  def compressed
    unless @compressed
      @compressed = newcmp_pack(uncompressed_1d)
      #@compressed = ext_zx0_pack(uncompressed_1d)
    end
    @compressed
  end

  def emit_section(chunk_name)
    s = ""
    s << ".SECTION \"base_#{chunk_name}\" SLOT 2 SUPERFREE\n"
    s << "#{chunk_name}:\n"
    s << ".DB " + compressed.map{|v| "$" + (v+0x100).to_s(16).upcase[1..]}.join(", ") + "\n"
    s << ".ENDS\n"
    s
  end
end
