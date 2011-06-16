class Folder < ActiveRecord::Base
  acts_as_tree

  attr_protected :folderable_id, :folderable_type

  belongs_to :folderable, :polymorphic => true
  belongs_to :root_folder,
    :class_name => 'Folder',
    :foreign_key => 'root_folder_id'
  has_many :documents, :dependent => :destroy

  validates_presence_of :name, :folderable_id, :folderable_type
  validates_length_of :name, :within => 1..255
  validates_uniqueness_of :name, :scope => [ :folderable_id, :folderable_type, :parent_id ]

  def validate
    if parent && folderable
      if parent.folderable != folderable
        errors.add_to_base("Invalid folder tree structure!")
      end
    end
  end

  before_validation :setup_folder
  before_destroy :destroy_children

  def title
    root? ? folderable.name : name
  end

  def root?
    root == self
  end

  def num_docs
    documents.count
  end

  def path
    ([self] + ancestors).reverse
  end

  def root
    root_folder || super
  end

  def tier
    if root?
      0
    else
      parent.tier + 1
    end
  end

  def folder_tree(exclude_self = false)
    conditions = if exclude_self
      ['id != ? AND (id = ? OR root_folder_id = ?)', id, root.id, root.id]
    else
      ['id = ? OR root_folder_id = ?', root.id, root.id]
    end
    Folder.all(:conditions => conditions, :order => 'parent_id ASC, name ASC')
  end

  protected

  def setup_folder
    if parent
      if !folderable
        self.folderable = parent.folderable
      end
      if !root_folder
        self.root_folder = root
      end
    end
  end

  def destroy_children
    children.each { |c| c.destroy }
  end

end
