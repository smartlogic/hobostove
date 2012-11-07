class InputPanel < Panel
  def <<(string)
    @strings = []

    super
  end

  def message
    @strings.first
  end

  def update_cursor
    @win.wmove(1, message.size)
  end
end
