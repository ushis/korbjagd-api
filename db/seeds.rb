# Create initial categories
%w(street court gym).each { |cat| Category.create!(name: cat) }
