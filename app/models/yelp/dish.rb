# encoding: utf-8

module Yelp
  class Dish < ActiveRecord::Base
    belongs_to :restaurant, :class_name => Yelp::Restaurant, :foreign_key => :ylp_restaraunt_id

    class << self
      def normalize(src)
        source = []
        source[0] = src


        source[0] = strip_quotes(source[0])
        source[0] = strip_noise(source[0])
        source[0] = strip_volume_metrics(source[0])
        source[0] = strip_weight_metrics(source[0])
        source[0] = normalize_start(source[0])
        source[0] = normalize_end(source[0])
        source[0] = strip_bad_words(source[0])
        source = normalize_brackets(source[0])
        source[0] = normalize_final(source[0])


        #self.normalized_name.gsub!(/1\/4Lb\s{1,}/, '')
        #self.normalized_name.gsub!(/\s{1}lt\s{1}/i, '')
        #self.normalized_name.gsub!(/\s{1}ft\s{0,1}/i, '')
        #self.normalized_name.gsub!(/\s{1,}lbs{1,}\.{0,1}/i, '')
        #self.normalized_name.gsub!(/\s{1,}pound{1,}/i, '')
        #
        #self.normalized_name.gsub!(/\d{0,}\s{0,}Oz\.?\s{1,}/, '')
        #self.normalized_name.gsub!(/\(\d{1,}\)/, '')
        #
        #self.normalized_name.gsub!(/\s{1}\$.+\s?/, '')
        #self.normalized_name.gsub!(/\([a-zA-Z0-9\s\+\-]{1,}\)/, '')
        #self.normalized_name.gsub!(/<[a-zA-Z0-9\s\+\-]{1,}>/, '')
        #
        #
        #self.normalized_name.gsub!(/^\(/, '')
        #
        #self.normalized_name.gsub!(/\)$/, '')
        #self.normalized_name.gsub!(/\d{1,}\sPc(s{0,1})\.{0,1}/i, '')
        #self.normalized_name.gsub!(/litro(s?)/i, '')
        #self.normalized_name.gsub!(/pint\s{1,}/i, '')
        #self.normalized_name.gsub!(/pint$/i, '')
        #self.normalized_name.gsub!(/lit{1,2}e(r?)(s?)/i, '')
        #self.normalized_name.gsub!(/bottles/i, '')
        #self.normalized_name.gsub!(/bottled/i, '')
        #self.normalized_name.gsub!(/bottle/i, '')
        #self.normalized_name.gsub!(/Lg Pc\./i, '')
        #
        #self.normalized_name.strip!
        #
        #self.normalized_name.gsub!(/^inch(s?){0,1}\.{0,1}\s{1,}/i, '')
        #self.normalized_name.gsub!(/^ib(s?){0,1}\.{0,1}\s{1,}/i, '')
        #self.normalized_name.gsub!(/^pt(s?){0,1}\.{0,1}/i, '')
        #self.normalized_name.gsub!(/^pd(s?){0,1}\.{0,1}/i, '')
        #self.normalized_name.gsub!(/^or\s{1,}/i, '')
        #self.normalized_name.gsub!(/^the\s{1,}/i, '')
        #self.normalized_name.gsub!(/^your choice\s{1,}/i, '')
        #self.normalized_name.gsub!(/^your\s{1,}/i, '')
        #self.normalized_name.gsub!(/^and\s{1,}/i, '')
        #
        #self.normalized_name.gsub!(/\s{1,}and$/i, '')
        #self.normalized_name.gsub!(/^order\s{1,}/i, '')
        #self.normalized_name.gsub!(/\d+\s{1,}order\s{1,}/i, '')
        #self.normalized_name.gsub!(/^size\s{1,}/i, '')
        #self.normalized_name.gsub!(/^orden\s{1,}/i, '')
        #self.normalized_name.gsub!(/^a\s{1,}/i, '')
        #self.normalized_name.gsub!(/^Lg\.{0,1}\s{1,}/i, '')
        #self.normalized_name.gsub!(/^doc\.{0,1}\s{1,}/i, '')
        #self.normalized_name.gsub!(/^dz\.{0,1}\s{1,}\s{1,}/i, '')
        #self.normalized_name.gsub!(/^dozen\s{1,}/i, '')
        #self.normalized_name.gsub!(/^pound\s{1,}/i, '')
        #self.normalized_name.gsub!(/^Lt\.{0,1}\s{1,}/i, '')
        #self.normalized_name.gsub!(/^Pc(s?)\.{0,1}\s{1,}/i, '')
        #self.normalized_name.gsub!(/^Pzs\.{0,1}\s{1,}/i, '')
        #self.normalized_name.gsub!(/^L\s{1}/i, '')
        #self.normalized_name.gsub!(/pt$/i, '')
        #
        #
        #self.normalized_name.gsub!(/-with/, 'with')
        #
        #self.normalized_name.strip!
        #
        #self.normalized_name.gsub!(/^lb(s?){0,1}(\.{0,1}|,{0,1})/i, '')
        #self.normalized_name.gsub!(/^er’s/i, '')
        #self.normalized_name.gsub!(/^th\s{1,}/i, '')
        #self.normalized_name.gsub!(/^’er\s{1,}/i, '')
        #self.normalized_name.gsub!(/^er(s?)\s{1,}/i, '')
        #self.normalized_name.gsub!(/\s{1,}de$/i, '')
        #self.normalized_name.gsub!(/X \d{1,} inch/i, '')
        #self.normalized_name.gsub!(/X \d{1,} single layer/i, '')
        #self.normalized_name.gsub!(/X \d{1,}/i, '')
        #self.normalized_name.gsub!(/^only$/i, '')
        #self.normalized_name.gsub!(/^st\s{1,}/i, '')
        #self.normalized_name.gsub!(/^everything$/i, '')
        #self.normalized_name.gsub!(/^everything includes$/i, '')
        #self.normalized_name.gsub!(/^special$/i, '')
        #self.normalized_name.gsub!(/^with milk$/i, '')
        #self.normalized_name.gsub!(/^cans$/i, '')
        #self.normalized_name.gsub!(/^quart$/i, '')
        #self.normalized_name.gsub!(/^quarter$/i, '')
        #self.normalized_name.gsub!(/^per person$/i, '')
        #self.normalized_name.gsub!(/^people and above$/i, '')
        #self.normalized_name.gsub!(/^cut$/i, '')
        #self.normalized_name.gsub!(/only$/i, '')
        #self.normalized_name.gsub!(/with$/i, '')
        #self.normalized_name.gsub!(/^only/i, '')
        #self.normalized_name.gsub!(/^large/i, '')
        #self.normalized_name.gsub!(/W\/fries$/i, '')
        #self.normalized_name.gsub!(/W\/(\s?)ff$/i, '')
        #self.normalized_name.gsub!(/W\/french fries$/i, '')
        #self.normalized_name.gsub!(/^bird$/i, '')
        #self.normalized_name.gsub!(/^subs$/i, '')
        #self.normalized_name.gsub!(/^extra cheese$/i, '')
        #self.normalized_name.gsub!(/^order$/i, '')
        #self.normalized_name.gsub!(/^leg$/i, '')
        #self.normalized_name.gsub!(/^wing$/i, '')
        #self.normalized_name.gsub!(/^pie$/i, '')
        #self.normalized_name.gsub!(/^pie each toppings$/i, '')
        #self.normalized_name.gsub!(/^pie topping$/i, '')
        #self.normalized_name.gsub!(/^thigh$/i, '')
        #self.normalized_name.gsub!(/^thigh or breast$/i, '')
        #self.normalized_name.gsub!(/^breast or thigh$/i, '')
        #self.normalized_name.gsub!(/^center breast$/i, '')
        #self.normalized_name.gsub!(/^pack$/i, '')
        #self.normalized_name.gsub!(/^rib$/i, '')
        #self.normalized_name.gsub!(/^rib only$/i, '')
        #self.normalized_name.gsub!(/^dark$/i, '')
        #self.normalized_name.gsub!(/^one combo$/i, '')
        #self.normalized_name.gsub!(/^combo$/i, '')
        #self.normalized_name.gsub!(/^pounder$/i, '')
        #self.normalized_name.gsub!(/^pounder basket$/i, '')
        #self.normalized_name.gsub!(/^with fries$/i, '')
        #self.normalized_name.gsub!(/^with fries and salad$/i, '')
        #self.normalized_name.gsub!(/^with french fries$/i, '')
        #self.normalized_name.gsub!(/^items$/i, '')
        #self.normalized_name.gsub!(/^item$/i, '')
        #self.normalized_name.gsub!(/^pound$/i, '')
        #self.normalized_name.gsub!(/^plain$/i, '')
        #self.normalized_name.gsub!(/^medium$/i, '')
        #self.normalized_name.gsub!(/^spice$/i, '')
        #self.normalized_name.gsub!(/^piece(s?)$/i, '')
        #self.normalized_name.gsub!(/^piece(s?)/i, '')
        #self.normalized_name.gsub!(/^ingredient pizza$/i, '')
        #self.normalized_name.gsub!(/^ingredient(s?)$/i, '')
        #self.normalized_name.gsub!(/^gallon$/i, '')
        #self.normalized_name.gsub!(/^guest(s?)$/i, '')
        #self.normalized_name.gsub!(/^salad$/i, '')
        #self.normalized_name.gsub!(/^top{2,3}ing(s?)/i, '')
        #self.normalized_name.gsub!(/^item combo$/i, '')
        #self.normalized_name.gsub!(/^milk or flavored milk$/i, '')
        #self.normalized_name.gsub!(/^milk$/i, '')
        #self.normalized_name.gsub!(/^sauce$/i, '')
        #self.normalized_name.gsub!(/slices/i, '')
        #self.normalized_name.gsub!(/sliced/i, '')
        #self.normalized_name.gsub!(/slice\s{1,}/i, '')
        #self.normalized_name.gsub!(/\(/, '')
        #self.normalized_name.gsub!(/\)/, '')
        #self.normalized_name.gsub!(/\d+(-)$/, '')
        #self.normalized_name.gsub!(/f\/f$/i, '')
        #
        #self.normalized_name.gsub!(/1\//i, '')
        #
        #self.normalized_name.strip!
        #
        #self.normalized_name.gsub!(/^with\s{1,}/i, '')
        #self.normalized_name.gsub!(/^,/, '')
        #self.normalized_name.gsub!(/^of\s{1,}/i, '')
        #self.normalized_name.gsub!(/^tray$/i, '')
        #self.normalized_name.gsub!(/^each$/i, '')
        #self.normalized_name.gsub!(/box of\s{1,}/i, '')
        #self.normalized_name.gsub!(/^bucket of\s{1,}/i, '')
        #self.normalized_name.gsub!(/^ch$/i, '')
        #self.normalized_name.gsub!(/^up or sprite$/i, '')
        #self.normalized_name.gsub!(/^double layer$/i, '')
        #self.normalized_name.gsub!(/^under$/i, '')
        #self.normalized_name.gsub!(/^x$/i, '')
        #self.normalized_name.gsub!(/^bucket$/i, '')
        #self.normalized_name.gsub!(/^choices$/i, '')
        #self.normalized_name.gsub!(/^different soups every day$/i, '')
        #self.normalized_name.gsub!(/^special$/i, '')
        #self.normalized_name.gsub!(/^large$/i, '')
        #self.normalized_name.gsub!(/^box$/i, '')
        #self.normalized_name.gsub!(/^order$/i, '')
        #self.normalized_name.gsub!(/^or more$/i, '')
        #self.normalized_name.gsub!(/^dinner$/i, '')
        #self.normalized_name.gsub!(/^seating$/i, '')
        #self.normalized_name.gsub!(/^extra item$/i, '')
        #
        #self.normalized_name.gsub!(/^and 12 Special$/i, '')
        #self.normalized_name.gsub!(/^wing(s?)$/i, '')
        #self.normalized_name.gsub!(/^w\/ french fries$/i, '')
        #self.normalized_name.gsub!(/^w\/ fries$/i, '')
        #self.normalized_name.gsub!(/^w\/ mozzarella$/i, '')

        if source[0] == '' && !source[1].nil? && source[1] != ''
          source[0] = source[1].dup
          source[1] = nil
        end

        source[1] = nil if source[0] == source[1]
        source[0] = '' if source[0] == 'Yelp::Dish'
        source.compact!
        source
      end

      def normalize_start(source)
        source.gsub!(/^\.\s{0,}/, '')
        source.gsub!(/^\-/, '')
        source.gsub!(/^★/, '')
        source.gsub!(/^•/, '')
        source.gsub!(/^#\s?\d{0,}\s?\.?/, '')
        source.gsub!(/^\d+[a-zA-Z]{0,}\./, '')
        source.gsub!(/^\$.+\s?/, '')
        source.gsub!(/^\s{0,}\d+(-?|,?)/, '')
        source.gsub!(/^\s{0,}\.{1}\d+/, '')
        source.gsub!(/^-/, '')
        source.gsub!(/^\d+(,)?/, '')
        source.gsub!(/^%/, '')
        source.gsub!(/^&{1}/i, '')
        source.gsub!(/^\//, '')
        source.gsub!(/^\+/, '')
        source = normalize_spaces(source)
        source.strip!
        source
      end

      def normalize_end(source)
        source.gsub!(/\d+$/, '')
        source.gsub!(/\#$/, '')
        source.gsub!(/\.{1,}$/, '')
        source.gsub!(/,$/, '')
        source.gsub!(/by the$/i, '')
        source = normalize_spaces(source)
        source.strip!
        source
      end

      def normalize_brackets(src)
        source = []
        source[0] = src

        m = source[0].match(/\(([,&a-z\s\d]+)\)/i)

        while !m.nil?
          #puts m.inspect
          source[0].gsub!(m[0], '')
          source[0].strip!
          normalized = m[1]
          normalized = normalize(normalized.dup)[0]
          source << normalized if normalized != '' && normalized != 'Yelp::Dish'
          #puts source[0]
          m = source[0].match(/\(([,&a-z\s\d]+)\)/i)
        end

        source[0].strip!
        source
      end

      def strip_quotes(source)
        source.gsub!(/"/, '')
        source.gsub!(/”/, '')
        source.gsub!(/“/, '')
        source.gsub!(/″/, '')
        source.gsub!(/‘/, '')
        source.gsub!(/‘/, '')
        source.gsub!(/\'/, '')
        source.gsub!(/’/, '')
        source = normalize_spaces(source)
        source.strip!
        source
      end

      def strip_noise(source)
        source.gsub!(/˚/, '')
        source.gsub!(/&#34/, '')
        source.gsub!(/ - /, ' ')
        source.gsub!(/\?/, '')
        source.gsub!(/\!/, '')
        source.gsub!(/\*/, '')
        source.gsub!(/\(\d+\)/, '')
        source.gsub!(/ \d+ /, ' ')
        source.gsub!(/\(.{1,2}\)/, '')
        source.gsub!(/\s{1}\$.+\s?/, '')
        source.gsub!(/ /, '')
        source = normalize_spaces(source)
        source.strip!
        source
      end

      def strip_volume_metrics(source)
        source.gsub!(/¼/, '')
        source.gsub!(/½/, '')
        source.gsub!(/1\/2\s{1,}/, '')
        source.gsub!(/1,2\s{1,}/, '')
        source.gsub!(/1,4\s{1,}/, '')
        source.gsub!(/1\/4(\s{1,}|lb)/i, '')
        source.gsub!(/lb(\.?|s)(\s{1,}|,)/i, '')
        source.gsub!(/\d{0,}pc(\.?|s)\s{1,}/i, '')
        source.gsub!(/lit(t?)(er|re)(s?)/i, '')
        source.gsub!(/(de )?litro(s?)/i, '')
        source.gsub!(/bottle(s|d)?/i, '')
        source.gsub!(/inch(s)?\.?\s{1,}/i, '')
        source = normalize_spaces(source)
        source.strip!
        source
      end

      def strip_weight_metrics(source)
        source.gsub!(/\(?\d{0,}\s{0,}[~a-z]?oz(\.{1}\)|\.\)|\.?(\s{1,}|\)|,))/i, '')
        source.gsub!(/pound(er)?/i, '')
        source = normalize_spaces(source)
        source.strip!
        source
      end

      def strip_bad_words(source)
        source.gsub!(/^th(e)?\s/i, '')
        source.gsub!(/^rd\s/i, '')
        source.gsub!(/pint\s/i, '')
        source = normalize_spaces(source)
        source.strip!
        source
      end

      def normalize_spaces(source)
        source.gsub!(/\s+/, ' ')
        source
      end

      def normalize_final(source)
        source.gsub!(/^take out only free$/i, '')
        source.gsub!(/^everything$/i, '')
        source.gsub!(/^everything includes$/i, '')
        source.gsub!(/^oz$/i, '')
        source.gsub!(/^quart$/i, '')
        source.gsub!(/^street$/i, '')
        source.gsub!(/^hole$/i, '')
        source.gsub!(/^platter$/i, '')
        source.gsub!(/^serves or more$/i, '')
        source.gsub!(/^scoop$/i, '')
        source.gsub!(/^add ins$/i, '')
        source.gsub!(/^two$/i, '')
        source.gsub!(/^inch$/i, '')
        source.gsub!(/^blt$/i, '')
        source.gsub!(/^stick(s)?$/i, '')
        source.gsub!(/^mix(ed)?$/i, '')
        source.gsub!(/^slice(d|s)?$/i, '')
        source.gsub!(/^select one item(s?) from (a|b)$/i, '')
        source.gsub!(/^large$/i, '')
        source.gsub!(/^selection(s)?$/i, '')
        source.gsub!(/^medium$/i, '')
        source.gsub!(/^best$/i, '')
        source.gsub!(/^for$/i, '')
        source.gsub!(/^sate$/i, '')
        source.gsub!(/^seasonal$/i, '')
        source.gsub!(/^side topping add$/i, '')
        source.gsub!(/^piece(s?)$/i, '')
        source.gsub!(/^each$/i, '')
        source.gsub!(/^(a )?topp(p)?ing(s)?( pizza)?$/i, '')
        source.gsub!(/^ft$/i, '')
        source.gsub!(/^Pie( Each )?Topping(s)?$/i, '')
        source.gsub!(/^topping slice$/i, '')
        source.gsub!(/^gallon$/i, '')
        source.gsub!(/^ingredient( pizza)?(s)?$/i, '')
        source.gsub!(/^st\s/i, '')
        source.gsub!(/^extra item$/i, '')
        source.gsub!(/^seating$/i, '')
        source.gsub!(/^choices$/i, '')
        source.gsub!(/^desserts$/i, '')
        source.gsub!(/^extra cheese$/i, '')
        source.gsub!(/^any flavor$/i, '')
        source.gsub!(/^(one|two|and) combo$/i, '')
        source.gsub!(/^item( (combo|bento))?( )?$/i, '')
        source.gsub!(/^(step )?items$/i, '')
        source.gsub!(/^pc(s?)$/i, '')
        source.gsub!(/^sheet$/i, '')
        source.gsub!(/^pack$/i, '')
        source.gsub!(/^combo$/i, '')
        source.gsub!(/^guests$/i, '')
        source.gsub!(/^tier$/i, '')
        source.gsub!(/^people and above$/i, '')
        source.gsub!(/^platter serves$/i, '')
        source.gsub!(/^each piece$/i, '')
        source.gsub!(/^box$/i, '')
        source.gsub!(/^boneless$/i, '')
        source.gsub!(/^under$/i, '')
        source.gsub!(/^can(s)?$/i, '')
        source.gsub!(/^cup(s)?$/i, '')
        source.gsub!(/^lb$/i, '')
        source.gsub!(/\swith$/i, '')
        source.gsub!(/^medium basket$/i, '')
        source.gsub!(/^bucket to go$/i, '')
        source.gsub!(/^or /i, '')
        source.gsub!(/only$/i, '')
        source.gsub!(/meal$/i, '')
        source.gsub!(/^only/i, '')
        source.gsub!(/pt$/i, '')
        source.gsub!(/-\d+/i, '')
        source.gsub!(/side(s)?$/i, '')
        source.gsub!(/\d+ people$/i, '')

        source.strip!

        source.gsub!(/^lg\.?\s{1,}/i, '')
        source.gsub!(/^pc(s)?(\.|,)?\s{1,}/i, '')
        source.gsub!(/^pd\.?\s{1,}/i, '')
        source.gsub!(/^ib\.?\s{1,}/i, '')
        source.gsub!(/^lt\.?\s{1,}/i, '')
        source.gsub!(/^lg\.?\s{1,}/i, '')
        source.gsub!(/^lt$/i, '')
        source.gsub!(/pt\.?\s{1,}/i, '')
        source.gsub!(/^orde(n|r)\s{1,}/i, '')
        source.gsub!(/^piece(s)?\s{1,}/i, '')
        source.gsub!(/^piece(s)?$/i, '')
        source.gsub!(/^of\s{1,}/i, '')
        source.gsub!(/^and\s{1,}/i, '')
        source.gsub!(/^in\s{1,}/i, '')
        source.gsub!(/\s{1,}and$/i, '')
        source.gsub!(/^to\s{1,}/i, '')
        source.gsub!(/^(with|w\s?\/)\s{1,}/i, '')
        source.gsub!(/^and$/i, '')
        source.gsub!(/^(in )?special$/i, '')
        source.gsub!(/^avenue$/i, '')
        source.gsub!(/^ward$/i, '')
        source.gsub!(/^course$/i, '')
        source.gsub!(/^oz\s{1,}/i, '')
        source.gsub!(/^pla\s{1,}/i, '')
        source.gsub!(/^size\s{1,}/i, '')
        source.gsub!(/^additional\s{1,}/i, '')
        source.gsub!(/^order$/i, '')
        source.gsub!(/^double layer$/i, '')
        source.gsub!(/^extra large$/i, '')
        source.gsub!(/^cut$/i, '')
        source.gsub!(/^dinner$/i, '')
        source.gsub!(/^in autumn sampler$/i, '')
        source.gsub!(/^mix$/i, '')
        source.gsub!(/^family$/i, '')
        source.gsub!(/^works with everything$/i, '')
        source.gsub!(/^l\s{1,}/i, '')
        source.gsub!(/lb$/i, '')
        source.gsub!(/order F\/f$/i, '')
        source.gsub!(/^x /i, '')
        source.gsub!(/^box of /i, '')
        source.gsub!(/^(e|i)r(s)?\s?/i, '')
        source.gsub!(/^bucket of /i, '')
        source.gsub!(/^pack of /i, '')
        source.gsub!(/^basket of /i, '')
        source.gsub!(/^pzs. /i, '')
        source.gsub!(/ pt /i, '')
        source.gsub!(/\d+\spp$/i, ' ')
        source.gsub!(/\s%\s\s$/i, ' ')
        source.gsub!(/-N-/i, ' & ')
        source.gsub!(/Slaw and Mash/i, 'Slaw & Mash')
        source.gsub!(/Treat®/i, 'Treat')
        source.gsub!(/\s[a-z]{1}\s/i, '')
        source.gsub!(/^[a-z]{1}\s/i, '')

        source.strip!
        source.gsub!(/^additional fruits$/i, '')
        source.gsub!(/^full sheet$/i, '')
        source.gsub!(/double$/i, '')

        source.gsub!(/\(/, '')
        source.gsub!(/\)/, '')
        source.gsub!(/\)$/, '')
        source.gsub!(/-$/, '')
        source.gsub!(/,/, ', ')

        source.strip!

        source = normalize_start(source)
        source = normalize_end(source)
        source = normalize_spaces(source)

        source.gsub!(/pcs$/i, '')
        source.gsub!(/lbs$/i, '')
        source.gsub!(/\d+pcs(\.)?\s/i, '')
        source.gsub!(/\spcs(\.)?\s/i, '')

        if (source.size == 1)
          source = self.name.dup
          source = strip_quotes(source)
          source.strip!
        end

        source.strip!
        source
      end
    end

  end
end
