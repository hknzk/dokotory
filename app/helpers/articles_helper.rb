module ArticlesHelper
  def options_for_select_from_enum(klass, column)
    enum_list = klass.send(column.to_s.pluralize)
    options = [['選択してください', nil]]
    enum_list.each do |name, value|
      options << [I18n.t("enums.#{klass.to_s.downcase}.#{column.to_s}.#{name}"),value]
    end
    return options
  end
end
