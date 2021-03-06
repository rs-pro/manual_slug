module ManualSlug::ActiveRecordMod
  extend ActiveSupport::Concern

  included do
    extend FriendlyId
  end

  def text_slug
    slug
  end
  def text_slug=(s)
    self.slug = s
  end

  module ClassMethods
    def manual_slug(field, options = {}, callback = true)
      unless options.key?(:use)
        options[:use] = [:finders, :slugged, :history]
      end

      friendly_id field, options

      define_method(:should_generate_new_friendly_id?) do
        slug.blank?
      end

      skip_callback :validation, :before, :set_slug
      before_validation do
        if self.slug.blank?
          self.send(:set_slug)
        end
        true
      end if callback
    end
  end
end

