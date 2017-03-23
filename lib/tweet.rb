class Tweet < LiveRecord

  define_attributes

  def description
    "#{username} says #{message}"
  end

end
