class CruceReport < Prawn::Document

  def to_pdf(reporte_marca)
    text reporte_marca.carta
    render
  end
end
