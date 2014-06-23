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
