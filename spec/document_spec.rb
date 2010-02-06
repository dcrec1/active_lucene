require 'spec_helper'

class Advertise < ActiveLucene::Document
end

describe Advertise do
  it "should be initialized without parameters" do
    lambda { Advertise.new }.should_not raise_error
  end

  context "in a Lucene index" do
    before :each do
      clean_index
    end

    it "should be saved" do
      title = "ruby programming"
      document = Advertise.new(:title => title).save
      search(:title => "programming").first.get_field("title").string_value.should eql(title)
    end

    it "should search by :attribute => 'value'" do
      Advertise.create! :name => "search lucene"
      Advertise.search(:name => "lucene").first.name.should eql("search lucene")
    end

    it "should be created" do
      description = "this is a little story"
      document = Advertise.create! :description => description
      search(:description => "story").first.get_field("description").string_value.should eql(description)
    end

    it "should save multiple documents in an index" do
      Advertise.create! :name => "Kate Moss"
      Advertise.create! :name => "Kate Perry"
      search(:name => "kate").size.should == 2
    end

    it "should search multiple documents" do
      Advertise.create! :place => "Rio de Janeiro"
      Advertise.create! :place => "Rio Amazonas"
      Advertise.search(:place => "rio").last.place.should eql("Rio Amazonas")
    end

    it "should search a document by a query like 'query'" do
      country = "Brazil"
      Advertise.create! :country => country
      Advertise.search("brazil").first.country.should eql(country)
    end

    it "should search multiple documents by a query like 'query'" do
      Advertise.create! :country => "Turkey"
      Advertise.create! :animal => "Turkey"
      Advertise.search("turkey").last.animal.should eql("Turkey")
    end

    it "should be updated if has an id" do
      Advertise.create!(:id => "15", :city => "Rome").update_attributes(:city => "London")
      Advertise.search("london").size.should == 1
    end

    it "should be saved with multiple fields" do
      Advertise.create! :param1 => "value1", :param2 => "value2"
      Advertise.search("value2").size.should == 1
    end

    it "should be destroyed if has id" do
      Advertise.create!(:id => "5", :dream => "sky").destroy
      Advertise.search("sky").should be_empty
    end

    it "should return the attributes" do
      attributes = {:param1 => "show", :param2 => "update"}
      Advertise.create! attributes
      Advertise.search("show").first.attributes.should eql(attributes.stringify_keys)
    end

    it "should return the id" do
      query, id = "easy", "16"
      Advertise.create! :how => query, :id => id
      Advertise.search(query).first.id.should eql(id)
    end

    it "should update attributes without loosing the old ones" do
      Advertise.create!(:name => "Diego", :lastname => "Carrion").update_attributes :lastname => "Carrion"
      Advertise.search("diego").should_not be_empty
    end

    it "should search documents ignoring the case" do
      Advertise.create! :name => "diego"
      Advertise.search("DIEGO").should_not be_empty
    end

    it "should find by id" do
      Advertise.create! :id => "50", :language => "ruby"
      Advertise.find("50").language.should eql("ruby")
    end

    it "should be saved always with an id" do
      framework = "rails"
      id = Advertise.create!(:framework => framework).id
      Advertise.find(id).framework.should eql(framework)
    end

    it "should find with wildcards" do
      Advertise.create! :food => "Pizza"
      Advertise.search("pi*a").should_not be_empty
    end

    it "should find with OR operator" do
      Advertise.create! :title => "blue red"
      Advertise.search("black OR red").should_not be_empty
    end

    it "should find given more than an attribute" do
      Advertise.create! :name => "John", :lastname => "Paul"
      Advertise.create! :name => "John", :lastname => "Lennon"
      Advertise.search(:name => "John", :lastname => "Lennon").size.should == 1
    end

    it "should return all documents" do
      5.times { Advertise.create! :year => "2009" }
      Advertise.find(:all).size.should == 5
    end

    it "should return an array of inherited model when searching for documents" do
      Advertise.create! :login => "dcrec1"
      Advertise.find(:all).first.should be_a(Advertise)
    end

    it "should highlight a term" do
      Advertise.create! :description => "the lazy fox over the whatever"
      Advertise.search("fox").first.highlight.should eql("the lazy <B>fox</B> over the whatever")
    end

    it "should return the total of pages of a search" do
      (Advertise::PER_PAGE + 1).times { Advertise.create! :label => "pagination" }
      Advertise.search("pagination").total_pages.should == 2
    end

    it "should be converted to a param" do
      Advertise.new(:id => "10").to_param.should eql("10")
    end

    it "should not loose id on update" do
      Advertise.create!(:id => "9").update_attributes!(:company => "MouseOver Studio").id.should eql("9")
    end
    
    it "should suggest a query to search" do
      Advertise.create!(:title => "ruby for dummies")
      Advertise.search("rubi for dumies").suggest.should eql("ruby for dummies")
    end
    
    it "should returns the current page as current_page" do
      (Advertise::PER_PAGE + 1).times { Advertise.create! :label => "pagination" }
      Advertise.search("pagination", :page => 2).current_page.should == 2
    end
    
    it "should be created without params" do
      Advertise.create!
      Advertise.find(:all).size.should == 1
    end
    
    it "should find all documents on all" do
      20.times { Advertise.create! }
      Advertise.all.size.should == 20
    end
    
    it "should return the page 1 as default" do
      Advertise.create!
      Advertise.all.current_page.should == 1
    end
    
    it "should return the documents for the current page" do
      (Advertise::PER_PAGE + 1).times { |i| Advertise.create! :title => "advertise #{i}" }
      Advertise.search("advertise", :page => 2).first.title.should eql("advertise #{Advertise::PER_PAGE}")
    end
    
    it "should accept the page as a string" do
      Advertise.create!
      Advertise.search("empty", :page => '2').should be_empty
    end
    
    it "should return the previous page of the current one" do
      Advertise.create!
      Advertise.search("whatever", :page => 5).previous_page.should == 4
    end
    
    it "should return the next page of the current one" do
      Advertise.create!
      Advertise.search("whatever", :page => 5).next_page.should == 6
    end
  end
end