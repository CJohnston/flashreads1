class Product < ActiveRecord::Base
  default_scope :order => 'title'
  has_many :line_items
  before_destroy :ensure_not_referenced_by_any_line_item

  validates :title, :author, :description, :genre, :image_url, :file_link, :presence => true
  validates :price, :numericality => {:greater_than_or_equal_to => 0.01}
  validates :title, :uniqueness => true
  validates :image_url, :format => {
      :with => %r{\.(gif|jpg|png)$}i,
      :message => 'must be a URL for GIF, JPG or PNG image.'
  }
  validates :file_link, :format => {
      :with => %r{\.(zip)$}i,
      :message => 'must be a link to a Zip file.'
  }

  def self.search(search_query)
    if search_query
      find(:all, :conditions => ['title LIKE ? or author LIKE ? or price LIKE ? or genre LIKE ?', "%#{ search_query}%", "%#{ search_query}%", "%#{ search_query}%", "%#{ search_query}%"])
    else
      find(:all)

    end
  end
  private

   # ensure that there are no line items referencing this product
   def ensure_not_referenced_by_any_line_item
     if line_items.count.zero?
       return true
     else
       errors[:base] << "Line Items present"
       return false
     end
   end
 end



