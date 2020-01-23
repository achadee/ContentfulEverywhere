class Entry < ApplicationRecord
  serialize :data
  # create a entry record from a response item
  # returns type entry
  #
  def self.create_from_contentful_item item
    entry = Entry.where(entry_id: item.id).first_or_initialize

    #
    # set the created at so it can be searched for later
    entry.created_on_contentful_at = item.sys[:created_at]

    entry.data = {
      sys: item.raw_with_links["sys"],
      fields: parse_fields(item)
    }

    #
    # save or create the new entry
    entry.save
  end

  # because the to_json doesnt work with links (stack level too deep - due
  # to recursive references) we have to parse it manually
  #
  def self.parse_fields item
    obj = {}
    item.fields.each do |name, value|

      # if its a one to many relation
      #
      if value.is_a? Array
        value.each do |child_node|

          # call the parse fields method again
          #

          if ["Contentful::Entry"].include?(child_node.class.to_s)
            obj[name] = parse_fields child_node
          else
            obj[name] = child_node
          end
        end
      else
        # if its a link to an asset parse it again
        #
        puts value.class
        if ["Contentful::Link", "Contentful::Entry"].include?(value.class.to_s)
          node = value.sys

          # dont need the env and space attributes on the payload
          #
          node.delete(:environment)
          node.delete(:space)
          node.delete(:content_type)

          # assign to the sys objects
          obj[name] = {sys: node}
        else
          # assign the object to the value
          #
          obj[name] = value
        end

      end
    end
    return obj
  end

end
