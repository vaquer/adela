module SectorsHelper
  def options_for_sectors_select
    Sector.all.map { |sector| [sector.title, sector.id] }
  end
end
