
describe %[Mu_Clean.attr "input", "name")] do

  it "returns nil if value has invalid characters" do
    Mu_Clean.attr("input", {"name"=>"$#%#%"}).should eq(nil)
  end

end # === describe

describe %[Mu_Clean.attr "input", "value"] do

  it "allows spaces" do
    val = " my val "
    Mu_Clean.attr("input", {"value" => val}).should eq({"value"=>val})
  end

  it "returns nil if tag name is not \"input\"" do
    Mu_Clean.attr("inputs", {"value"=>" hidden "}).should eq(nil)
  end

end # === describe

describe %[Mu_Clean.attr "input" {"type"=>"hidden"}] do

  it "returns the same value" do
    Mu_Clean.attr("input", {"name"=>"hidden"}).should eq({"name"=>"hidden"})
  end

  it "returns nil if value is not \"hidden\"" do
    Mu_Clean.attr("input", {"name"=>" hidden "}).should eq(nil)
  end

end # === describe

describe %[ Mu_Clean.attr tag_name, {"class"=>val} ] do

  it "allows spaces" do
    val = " my class "
    Mu_Clean.attr("div", {"class"=>val}).should eq({"class"=>val})
  end

end # === describe

describe %[ Mu_Clean.attr("a", {"href"=>val} ] do

  it "returns nil if value is an invalid uri" do
    Mu_Clean.attr("a", {"href"=>"javascript://alert()"}).should eq(nil)
  end

  it "returns value if value is a valid uri" do
    Mu_Clean.attr("a", {"href"=>"/home/home/home"}).should eq({"href"=>"/home/home/home"})
  end

end # === describe

describe %[ Mu_Clean.attr("form", "action", val) ] do
  it "returns nil if value is an invalid uri" do
    Mu_Clean.attr("form", {"action"=>"javascript://alert()"}).should eq(nil)
  end

  it "returns nil if value is not a path" do
    Mu_Clean.attr("form", {"action"=>"http://my.uri/"}).should eq(nil)
  end

  it "allows a value of a relative path" do
    Mu_Clean.attr("form", {"action"=>"/my.uri/"}).should eq({"action"=>"/my.uri/"})
  end
end # === describe

describe %[ Mu_Clean.attr("meta", {"keywords"=>" <a> "}) ] do

  it "HTML escapes values" do
    Mu_Clean.attr("meta", {"name"=>"keywords", "content"=>" <a> "}).should eq({"name"=>"keywords", "content"=>" &lt;a&gt; "})
  end

end # === describe

describe %[ Mu_Clean.attr("meta", {"charset"=>"utf-8"}) ] do
  it "allows charset" do
    Mu_Clean.attr("meta", {"charset"=>"utf-8"}).should eq({"charset"=>"utf-8"})
  end
end # === describe
