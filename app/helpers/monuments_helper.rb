module MonumentsHelper
  def build_monument(monument)
    monument.pictures.build if monument.pictures.empty?
    monument
  end

  def generate_field(f, association)
    new_object = f.object.class.reflect_on_association(association).klass.new
    fields = f.fields_for(association, new_object, :child_index => "new_#{association}") do |builder|
      render(association.to_s, :builder => builder)
    end
  end
end