require_relative 'db_connection'
require 'byebug'
require 'active_support/inflector'
# NB: the attr_accessor we wrote in phase 0 is NOT used in the rest
# of this project. It was only a warm up.
require_relative '00_attr_accessor_object.rb'
class SQLObject
  def self.columns
    cols = DBConnection.execute2(<<-SQL).first

    SELECT
      *
    FROM
      #{table_name}
     Limit 0
    SQL
    @colums = cols.map!(&:to_sym)
    # debugger
  end

  def self.finalize!
    
    self.columns.each do |name|
        define_method(name) do
          self.attributes[name]
        end

        define_method("#{name}=") do |val|
          self.attributes[name] = val
        end

    end
  end

  def self.table_name=(table_name)
    @table_name = table_name
  end

  def self.table_name
    # ...
    @table_name || self.name.downcase.pluralize
  end

  def self.all
    # debugger # 
    all_vals = DBConnection.execute(<<-SQL)
    SELECT
    #{table_name}.*
    FROM
      #{table_name}
    SQL
    # ...
    self.parse_all(all_vals)
  end

  def self.parse_all(results)
    #results = [{:name=>"cat1", :owner_id=>1}, {:name=>"cat2", :owner_id=>2}]
   
    results.map do |hash|
      self.new(hash)
    end

  end

  def self.find(id)
    finding = DBConnection.execute(<<-SQL, id)
    SELECT
    #{table_name}.*
    FROM
      #{table_name}
      WHERE
      #{table_name}.id = ?
    SQL

    parse_all(finding).first

  end

  def initialize(params = {})
    params.each do |attr_name, value|
      temp = attr_name.to_sym
      if self.class.columns.include?(temp)
        self.send("#{temp}=", value)      
      else
        raise "unknown attribute '#{temp}'"  
      end

    end
  end

  def attributes
   @attributes ||= {}
  end

  def attribute_values
    
  end

  def insert
    # ...
    col_names = self.class.columns.join(",")
    debugger
    # question_mark = 
  end

  def update
    # ...
  end

  def save
    # ...
  end
end
