module Hobostove
  class Line
    LineSegment = Struct.new(:color, :body)

    attr_reader :segments

    def initialize(segments = [])
      @segments = segments
    end

    def to_s
      @segments.map(&:body).join
    end

    def first(count)
      new_line = Line.new

      segments.inject(0) do |current_count, segment|
        next if current_count > count
        current_count += segment.body.length
        if current_count <= count
          new_line.add(segment.color, segment.body)
        else
          count = segment.body.length - (current_count - count)
          new_line.add(segment.color, segment.body.first(count))
        end
        current_count
      end

      new_line
    end

    def add(color, body)
      segments << LineSegment.new(color, body)
    end

    def <=>(other)
      to_s <=> other.to_s
    end
  end
end

def Line(obj)
  if obj.is_a?(Hobostove::Line)
    obj
  else
    Hobostove::Line.new.tap do |line|
      line.add(:white, obj.to_s)
    end
  end
end
