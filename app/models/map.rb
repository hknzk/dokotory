class Map < ApplicationRecord

  belongs_to :article

  scope :active_maps, -> { where(is_enabled: true, is_article_published: true) }

end
