# Modulo para poder realizar mejor paginacion
module ModMarca::Paginacion

  # metodo usado para poder crear la paginacion
  def crear_paginacion(options = {})
    @options = options
    @page_size = (options[:page_size] || 10).to_i
    define_total_pages(@page_size)
    define_current_page
    define_previous_page
    define_next_page
    self.limit(@page_size).offset(options[:page].to_i * @page_size)
  end

  def define_total_pages(page_size)
    pages = self.size / page_size
    self.instance_eval <<-PAGE
      def total_pages
        #{pages}
      end
    PAGE
  end

  def define_current_page
    self.instance_eval <<-PAGE, __FILE__, __LINE__ + 1
      def current_page
        #{@options[:page].to_i}
      end
    PAGE
  end

  def define_previous_page
    page = @options[:page].to_i - 1
    page = nil if page <= 0
    self.instance_eval <<-PAGE
      def previous_page
        #{page}
      end
    PAGE
  end

  def define_next_page
    page = @options[:page].to_i + 1
    page = nil if self.current_page == self.total_pages
    self.instance_eval <<-PAGE
      def next_page
        #{page}
      end
    PAGE
  end

end
