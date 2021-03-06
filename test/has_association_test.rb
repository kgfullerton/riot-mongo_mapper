require File.expand_path('../teststrap', __FILE__)

context "has_association macro" do
  helper(:macro) { RiotMongoMapper::HasAssociationAssertion.new }

  setup do
    mock_model do
      many :persons
      many :categories, :in => :category_ids, :class_name => 'Tags'
    end
  end
  
  asserts "passes when has association" do
    macro.evaluate(topic, :many, :persons).first
  end.equals(:pass)
  
  asserts "fails when has association" do
    macro.evaluate(topic, :many, :dogs).first
  end.equals(:fail)
  
  asserts "passes when association options is specified" do
    macro.evaluate(topic, :many, :categories, :in => :category_ids, :class_name => 'Tags').first
  end.equals(:pass)
  
  asserts "fails when the options don't match" do
    macro.evaluate(topic, :many, :categories, :foreign_id => 'wtf').first
  end.equals(:fail)
  
  asserts "returns a message" do
    macro.evaluate(topic, :many, :persons).last
  end.matches %r{has association 'many' on 'persons' with options}
  
end
