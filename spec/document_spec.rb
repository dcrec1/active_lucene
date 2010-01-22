require 'spec_helper'

class Advertise < Lunr::Document
end

describe Document do
  it "should be initialized without parameters" do
    lambda { Document.new }.should_not raise_error
  end

  context "in a Lucene index" do
    before :each do
      clean_index
    end

    it "should be saved" do
      title = "ruby programming"
      document = Document.new(:title => title).save
      search(:title => "programming").first.get_field("title").string_value.should eql(title)
    end

    it "should search by :attribute => 'value'" do
      name = "search lucene"
      save :name => name
      Document.search(:name => "lucene").first.name.should eql(name)
    end

    it "should be created" do
      description = "this is a little story"
      document = Document.create! :description => description
      search(:description => "story").first.get_field("description").string_value.should eql(description)
    end

    it "should save multiple documents in an index" do
      Document.create! :name => "Kate Moss"
      Document.create! :name => "Kate Perry"
      search(:name => "kate").size.should == 2
    end

    it "should search multiple documents" do
      save :place => "Rio de Janeiro"
      save :place => "Rio Amazonas"
      Document.search(:place => "rio").last.place.should eql("Rio Amazonas")
    end

    it "should search a document by a query like 'query'" do
      country = "Brazil"
      Document.create! :country => country
      Document.search("brazil").first.country.should eql(country)
    end

    it "should search multiple documents by a query like 'query'" do
      Document.create! :country => "Turkey"
      Document.create! :animal => "Turkey"
      Document.search("turkey").last.animal.should eql("Turkey")
    end

    it "should be updated if has an id" do
      Document.create!(:id => "15", :city => "Rome").update_attributes(:city => "London")
      Document.search("london").size.should == 1
    end

    it "should be saved with multiple fields" do
      Document.create! :param1 => "value1", :param2 => "value2"
      Document.search("value2").size.should == 1
    end

    it "should be destroyed if has id" do
      Document.create!(:id => "5", :dream => "sky").destroy
      Document.search("sky").should be_empty
    end

    it "should return the attributes" do
      attributes = {:param1 => "show", :param2 => "update"}
      Document.create! attributes
      Document.search("show").first.attributes.should eql(attributes.stringify_keys)
    end

    it "should return the id" do
      query, id = "easy", "16"
      Document.create! :how => query, :id => id
      Document.search(query).first.id.should eql(id)
    end

    it "should update attributes without loosing the old ones" do
      Document.create!(:name => "Diego", :lastname => "Carrion").update_attributes :lastname => "Carrion"
      Document.search("diego").should_not be_empty
    end

    it "should search documents ignoring the case" do
      Document.create! :name => "diego"
      Document.search("DIEGO").should_not be_empty
    end

    it "should find by id" do
      Document.create! :id => "50", :language => "ruby"
      Document.find("50").language.should eql("ruby")
    end

    it "should be saved always with an id" do
      framework = "rails"
      id = Document.create!(:framework => framework).id
      Document.find(id).framework.should eql(framework)
    end

    it "should find with wildcards" do
      Document.create! :food => "Pizza"
      Document.search("pi*a").should_not be_empty
    end

    it "should find with OR operator" do
      Document.create! :title => "blue red"
      Document.search("black OR red").should_not be_empty
    end

    it "should find given more than an attribute" do
      Document.create! :name => "John", :lastname => "Paul"
      Document.create! :name => "John", :lastname => "Lennon"
      Document.search(:name => "John", :lastname => "Lennon").size.should == 1
    end

    it "should return all documents" do
      5.times { Document.create! :year => "2009" }
      Document.find(:all).size.should == 5
    end

    it "should return an array of inherited model when searching for documents" do
      Advertise.create! :login => "dcrec1"
      Advertise.find(:all).first.should be_a(Advertise)
    end

    it "should highlight a term" do
      Document.create! :description => "the lazy fox over the whatever"
      Document.search("fox").first.highlight.should eql("the lazy <B>fox</B> over the whatever")
    end

    it "should return the total of pages of a search" do
      (Document::PER_PAGE + 1).times { Advertise.create! :label => "pagination" }
      Document.search("pagination").total_pages.should == 2
    end

    it "should be converted to a param" do
      Document.new(:id => "10").to_param.should eql("10")
    end

    it "should not loose id on update" do
      Document.create!(:id => "9").update_attributes!(:company => "MouseOver Studio").id.should eql("9")
    end
  end
end
