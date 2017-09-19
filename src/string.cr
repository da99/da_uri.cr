
module Mu_Clean

  def string(*args)
    String_.clean *args
  end # === def string

  module String_

    extend self

    def clean(s : String)
      if s.valid_encoding?
        s.gsub("\t", "  ")
      else
        nil
      end
    end # === def clean

  end # === module String_

end # === module Mu_Clean
