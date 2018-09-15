class WeatherData

  def initialize file:
    @file = file
    @data = []
    @smallest_temp = 0
  end

  def getWeatherData

    array_index = []
    first_line = @file.first.split('')

    first_line.each_with_index do |element, i|
      array_index << i-1 if i > 0 && first_line[i-1] != ' ' && first_line[i] == ' '
    end
    array_index << first_line.length - 1

    @file.readlines.each_with_index do |line, i|
      str_array = [line[0 .. array_index[0]]]

      if i > 0

        array_index.each_cons 2 do |index, next_index|

          str_array << (line[index+1 .. next_index])

        end

        @data << str_array

      end

    end

    @smallest_temp = @data[0]

    @data.each_with_index do |info, i|

      #remueve todos los caracteres no numericos y lo castea a un float
      current_small_temp = @smallest_temp[2].tr('^0-9', '').to_f
      current_info_temp = info[2].tr('^0-9', '').to_f

      @smallest_temp = info if current_small_temp > current_info_temp && i < @data.length - 1

    end
    @smallest_temp[0].delete! " "
  end

end


class FootballData

  def initialize file:
    @file = file
    @data = []
    @smallest_diff = 0
  end

  def getFootballData

    array_index = []
    first_line = @file.first.split('')

    first_line.each_with_index do |element, i|
      array_index << i-1 if i > 0 && first_line[i-1] == ' ' && first_line[i] != ' '
    end

    array_index << first_line.length

    @file.readlines.each do |line|

      str_array = []

      # string.include? 'substring' determina si el string contiene el substring especificado
      if !line.include? '---'

        array_index.each_cons 2 do |index, next_index|
          str_array << (line[index .. next_index-1])
        end

        @data << str_array

      end

    end

    @smallest_diff = @data[0]

    @data.each do |info|

      current_small_diff = (@smallest_diff[5].tr('^0-9', '').to_f - @smallest_diff[6].tr('^0-9', '').to_f).abs
      current_info_diff = (info[5].tr('^0-9', '').to_f - info[6].tr('^0-9', '').to_f).abs

      @smallest_diff = info if current_small_diff > current_info_diff

    end
    @smallest_diff[0].delete! " "
  end

end

weather_file = File.open('weather.txt', 'r')
weather_data = WeatherData.new file: weather_file
football_file = File.open('football.txt', 'r')
football_data = FootballData.new file: football_file

puts "Dia con la temperatura mas baja: #{weather_data.getWeatherData} de junio"
puts "Equipo con la menor diferencia de goles (F - A): #{football_data.getFootballData}"
