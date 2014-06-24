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

    def length
      to_s.length
    end

    def present?
      to_s.present?
    end

    def first(count)
      segment(count).first
    end

    def split(width)
      lines = []
      line = self
      begin
        first, second = line.send(:segment, width)

        lines << first
        line = second
      end while second.length > 0
      lines
    end

    def add(color, body)
      segments << LineSegment.new(color, body)
    end

    def <=>(other)
      to_s <=> other.to_s
    end

    def segment(count)
      first_line = Line.new
      second_line = Line.new

      segments.inject(0) do |current_count, segment|
        if current_count > count
          second_line.add(segment.color, segment.body)
          next
        end

        current_count += segment.body.length

        if current_count <= count
          first_line.add(segment.color, segment.body)
        else
          count = segment.body.length - (current_count - count)

          first_line.add(segment.color, segment.body.first(count))
          second_line.add(segment.color, segment.body[count..-1])
        end

        current_count
      end

      [first_line, second_line]
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
