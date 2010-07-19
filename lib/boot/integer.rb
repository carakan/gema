Integer.class_eval do
  def to_byte_size(r=2)
    case
      when self < 1.kilobyte then "#{self.to_f.round(r)} bytes"
      when self < 1.megabyte then "#{(self.to_f/1.kilobyte).round(r)} Kb"
      when self < 1.gigabyte then "#{(self.to_f/1.megabyte).round(r)} MB"
      when self < 1.terabyte then "#{(self.to_f/1.gigabyte).round(r)} GB"
      when self < 1.petabyte then "#{(self.to_f/1.terabyte).round(r)} TB"
      when self < 1.exabyte then "#{(self.to_f/1.petabyte).round(r)} PB"
      else
        "#{(self.to_f/1.exabyte).round(r)} EB"
    end
  end

  # Convierte un mumero a una columna de una hoja electronica
  # @param Integer num
  def excel_col()
    ( ( ( (self - 1)/26>=1) ? ( (self - 1)/26+64).chr: '') + ((self - 1)%26+65).chr)
  end
end
