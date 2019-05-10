module Subs

  class Language

    attr_reader :name
    attr_reader :alpha3
    attr_reader :alpha2

    def initialize(name, alpha3, alpha2 = nil)
      @name = name
      @alpha3 = alpha3
      @alpha2 = alpha2
    end
    
    def ==(other)
      other.is_a?(Language) && @alpha3 == other.alpha3
    end

    def to_s
      @alpha3.to_s
    end

    def self.from_name(name)
      return nil if name.nil?
      result = database.find { |_, v| v.name.casecmp(name).zero? }
      return result.last if result
      name = name.downcase
      database.find_all { |_, v| v.name.downcase.include?(name) }
    end

    def self.from_alpha3(code)
      database[code.to_sym]
    end

    def self.from_alpha2(code)
      code = code.to_sym
      database.values.find { |language| code == language.alpha2 }
    end

    def self.database
      @database ||= {
        aar: Language.new("Afar", :aar, :aa),
        abk: Language.new("Abkhazian", :abk, :ab),
        ace: Language.new("Achinese", :ace),
        ach: Language.new("Acoli", :ach),
        ada: Language.new("Adangme", :ada),
        ady: Language.new("adyghé", :ady),
        afa: Language.new("Afro-Asiatic", :afa),
        afh: Language.new("Afrihili", :afh),
        afr: Language.new("Afrikaans", :afr, :af),
        ain: Language.new("Ainu", :ain),
        aka: Language.new("Akan", :aka, :ak),
        akk: Language.new("Akkadian", :akk),
        alb: Language.new("Albanian", :alb, :sq),
        ale: Language.new("Aleut", :ale),
        alg: Language.new("Algonquian", :alg),
        alt: Language.new("Southern Altai", :alt),
        amh: Language.new("Amharic", :amh, :am),
        ang: Language.new("Old English", :ang),
        apa: Language.new("Apache", :apa),
        ara: Language.new("Arabic", :ara, :ar),
        arc: Language.new("Aramaic", :arc),
        arg: Language.new("Aragonese", :arg, :an),
        arm: Language.new("Armenian", :arm, :hy),
        arn: Language.new("Araucanian", :arn),
        arp: Language.new("Arapaho", :arp),
        art: Language.new("Artificial", :art),
        arw: Language.new("Arawak", :arw),
        asm: Language.new("Assamese", :asm, :as),
        ast: Language.new("Asturian", :ast, :at),
        ath: Language.new("Athapascan", :ath),
        aus: Language.new("Australian ", :aus),
        ava: Language.new("Avaric", :ava, :av),
        ave: Language.new("Avestan", :ave, :ae),
        awa: Language.new("Awadhi", :awa),
        aym: Language.new("Aymara", :aym, :ay),
        aze: Language.new("Azerbaijani", :aze, :az),
        bad: Language.new("Banda", :bad),
        bai: Language.new("Bamileke", :bai),
        bak: Language.new("Bashkir", :bak, :ba),
        bal: Language.new("Baluchi", :bal),
        bam: Language.new("Bambara", :bam, :bm),
        ban: Language.new("Balinese", :ban),
        baq: Language.new("Basque", :baq, :eu),
        bas: Language.new("Basa", :bas),
        bat: Language.new("Baltic", :bat),
        bej: Language.new("Beja", :bej),
        bel: Language.new("Belarusian", :bel, :be),
        bem: Language.new("Bemba", :bem),
        ben: Language.new("Bengali", :ben, :bn),
        ber: Language.new("Berber", :ber),
        bho: Language.new("Bhojpuri", :bho),
        bih: Language.new("Bihari", :bih, :bh),
        bik: Language.new("Bikol", :bik),
        bin: Language.new("Bini", :bin),
        bis: Language.new("Bislama", :bis, :bi),
        bla: Language.new("Siksika", :bla),
        bnt: Language.new("Bantu", :bnt),
        bos: Language.new("Bosnian", :bos, :bs),
        bra: Language.new("Braj", :bra),
        bre: Language.new("Breton", :bre, :br),
        btk: Language.new("Batak", :btk),
        bua: Language.new("Buriat", :bua),
        bug: Language.new("Buginese", :bug),
        bul: Language.new("Bulgarian", :bul, :bg),
        bur: Language.new("Burmese", :bur, :my),
        byn: Language.new("Blin", :byn),
        cad: Language.new("Caddo", :cad),
        cai: Language.new("Central American Indian", :cai),
        car: Language.new("Carib", :car),
        cat: Language.new("Catalan", :cat, :ca),
        cau: Language.new("Caucasian", :cau),
        ceb: Language.new("Cebuano", :ceb),
        cel: Language.new("Celtic", :cel),
        cha: Language.new("Chamorro", :cha, :ch),
        chb: Language.new("Chibcha", :chb),
        che: Language.new("Chechen", :che, :ce),
        chg: Language.new("Chagatai", :chg),
        chi: Language.new("Chinese", :chi, :zh),
        chk: Language.new("Chuukese", :chk),
        chm: Language.new("Mari", :chm),
        chn: Language.new("Chinook jargon", :chn),
        cho: Language.new("Choctaw", :cho),
        chp: Language.new("Chipewyan", :chp),
        chr: Language.new("Cherokee", :chr),
        chu: Language.new("Church Slavic", :chu, :cu),
        chv: Language.new("Chuvash", :chv, :cv),
        chy: Language.new("Cheyenne", :chy),
        cmc: Language.new("Chamic", :cmc),
        cop: Language.new("Coptic", :cop),
        cor: Language.new("Cornish", :cor, :kw),
        cos: Language.new("Corsican", :cos, :co),
        cpe: Language.new("Creoles and pidgins, English based", :cpe),
        cpf: Language.new("Creoles and pidgins, French-based", :cpf),
        cpp: Language.new("Creoles and pidgins, Portuguese-based", :cpp),
        cre: Language.new("Cree", :cre, :cr),
        crh: Language.new("Crimean Tatar", :crh),
        crp: Language.new("Creoles and pidgins", :crp),
        csb: Language.new("Kashubian", :csb),
        cus: Language.new("Cushitic", :cus),
        cze: Language.new("Czech", :cze, :cs),
        dak: Language.new("Dakota", :dak),
        dan: Language.new("Danish", :dan, :da),
        dar: Language.new("Dargwa", :dar),
        day: Language.new("Dayak", :day),
        del: Language.new("Delaware", :del),
        den: Language.new("Slave (Athapascan)", :den),
        dgr: Language.new("Dogrib", :dgr),
        din: Language.new("Dinka", :din),
        div: Language.new("Divehi", :div, :dv),
        doi: Language.new("Dogri", :doi),
        dra: Language.new("Dravidian", :dra),
        dua: Language.new("Duala", :dua),
        dum: Language.new("Dutch, Middle (ca.1050-1350)", :dum),
        dut: Language.new("Dutch", :dut, :nl),
        dyu: Language.new("Dyula", :dyu),
        dzo: Language.new("Dzongkha", :dzo, :dz),
        efi: Language.new("Efik", :efi),
        egy: Language.new("Egyptian (Ancient)", :egy),
        eka: Language.new("Ekajuk", :eka),
        elx: Language.new("Elamite", :elx),
        eng: Language.new("English", :eng, :en),
        enm: Language.new("English, Middle (1100-1500)", :enm),
        epo: Language.new("Esperanto", :epo, :eo),
        est: Language.new("Estonian", :est, :et),
        ewe: Language.new("Ewe", :ewe, :ee),
        ewo: Language.new("Ewondo", :ewo),
        fan: Language.new("Fang", :fan),
        fao: Language.new("Faroese", :fao, :fo),
        fat: Language.new("Fanti", :fat),
        fij: Language.new("Fijian", :fij, :fj),
        fil: Language.new("Filipino", :fil),
        fin: Language.new("Finnish", :fin, :fi),
        fiu: Language.new("Finno-Ugrian", :fiu),
        fon: Language.new("Fon", :fon),
        fre: Language.new("French", :fre, :fr),
        frm: Language.new("French, Middle (ca.1400-1600)", :frm),
        fro: Language.new("French, Old (842-ca.1400)", :fro),
        fry: Language.new("Frisian", :fry, :fy),
        ful: Language.new("Fulah", :ful, :ff),
        fur: Language.new("Friulian", :fur),
        gaa: Language.new("Ga", :gaa),
        gay: Language.new("Gayo", :gay),
        gba: Language.new("Gbaya", :gba),
        gem: Language.new("Germanic", :gem),
        geo: Language.new("Georgian", :geo, :ka),
        ger: Language.new("German", :ger, :de),
        gez: Language.new("Geez", :gez),
        gil: Language.new("Gilbertese", :gil),
        gla: Language.new("Gaelic", :gla, :gd),
        gle: Language.new("Irish", :gle, :ga),
        glg: Language.new("Galician", :glg, :gl),
        glv: Language.new("Manx", :glv, :gv),
        gmh: Language.new("German, Middle High (ca.1050-1500)", :gmh),
        goh: Language.new("German, Old High (ca.750-1050)", :goh),
        gon: Language.new("Gondi", :gon),
        gor: Language.new("Gorontalo", :gor),
        got: Language.new("Gothic", :got),
        grb: Language.new("Grebo", :grb),
        grc: Language.new("Greek, Ancient (to 1453)", :grc),
        ell: Language.new("Greek", :ell, :el),
        grn: Language.new("Guarani", :grn, :gn),
        guj: Language.new("Gujarati", :guj, :gu),
        gwi: Language.new("Gwich´in", :gwi),
        hai: Language.new("Haida", :hai),
        hat: Language.new("Haitian", :hat, :ht),
        hau: Language.new("Hausa", :hau, :ha),
        haw: Language.new("Hawaiian", :haw),
        heb: Language.new("Hebrew", :heb, :he),
        her: Language.new("Herero", :her, :hz),
        hil: Language.new("Hiligaynon", :hil),
        him: Language.new("Himachali", :him),
        hin: Language.new("Hindi", :hin, :hi),
        hit: Language.new("Hittite", :hit),
        hmn: Language.new("Hmong", :hmn),
        hmo: Language.new("Hiri Motu", :hmo, :ho),
        hrv: Language.new("Croatian", :hrv, :hr),
        hun: Language.new("Hungarian", :hun, :hu),
        hup: Language.new("Hupa", :hup),
        iba: Language.new("Iban", :iba),
        ibo: Language.new("Igbo", :ibo, :ig),
        ice: Language.new("Icelandic", :ice, :is),
        ido: Language.new("Ido", :ido, :io),
        iii: Language.new("Sichuan Yi", :iii, :ii),
        ijo: Language.new("Ijo", :ijo),
        iku: Language.new("Inuktitut", :iku, :iu),
        ile: Language.new("Interlingue", :ile, :ie),
        ilo: Language.new("Iloko", :ilo),
        ina: Language.new("Interlingua (International Auxiliary Language Asso", :ina, :ia),
        inc: Language.new("Indic", :inc),
        ind: Language.new("Indonesian", :ind, :id),
        ine: Language.new("Indo-European", :ine),
        inh: Language.new("Ingush", :inh),
        ipk: Language.new("Inupiaq", :ipk, :ik),
        ira: Language.new("Iranian", :ira),
        iro: Language.new("Iroquoian", :iro),
        ita: Language.new("Italian", :ita, :it),
        jav: Language.new("Javanese", :jav, :jv),
        jpn: Language.new("Japanese", :jpn, :ja),
        jpr: Language.new("Judeo-Persian", :jpr),
        jrb: Language.new("Judeo-Arabic", :jrb),
        kaa: Language.new("Kara-Kalpak", :kaa),
        kab: Language.new("Kabyle", :kab),
        kac: Language.new("Kachin", :kac),
        kal: Language.new("Kalaallisut", :kal, :kl),
        kam: Language.new("Kamba", :kam),
        kan: Language.new("Kannada", :kan, :kn),
        kar: Language.new("Karen", :kar),
        kas: Language.new("Kashmiri", :kas, :ks),
        kau: Language.new("Kanuri", :kau, :kr),
        kaw: Language.new("Kawi", :kaw),
        kaz: Language.new("Kazakh", :kaz, :kk),
        kbd: Language.new("Kabardian", :kbd),
        kha: Language.new("Khasi", :kha),
        khi: Language.new("Khoisan", :khi),
        khm: Language.new("Khmer", :khm, :km),
        kho: Language.new("Khotanese", :kho),
        kik: Language.new("Kikuyu", :kik, :ki),
        kin: Language.new("Kinyarwanda", :kin, :rw),
        kir: Language.new("Kirghiz", :kir, :ky),
        kmb: Language.new("Kimbundu", :kmb),
        kok: Language.new("Konkani", :kok),
        kom: Language.new("Komi", :kom, :kv),
        kon: Language.new("Kongo", :kon, :kg),
        kor: Language.new("Korean", :kor, :ko),
        kos: Language.new("Kosraean", :kos),
        kpe: Language.new("Kpelle", :kpe),
        krc: Language.new("Karachay-Balkar", :krc),
        kro: Language.new("Kru", :kro),
        kru: Language.new("Kurukh", :kru),
        kua: Language.new("Kuanyama", :kua, :kj),
        kum: Language.new("Kumyk", :kum),
        kur: Language.new("Kurdish", :kur, :ku),
        kut: Language.new("Kutenai", :kut),
        lad: Language.new("Ladino", :lad),
        lah: Language.new("Lahnda", :lah),
        lam: Language.new("Lamba", :lam),
        lao: Language.new("Lao", :lao, :lo),
        lat: Language.new("Latin", :lat, :la),
        lav: Language.new("Latvian", :lav, :lv),
        lez: Language.new("Lezghian", :lez),
        lim: Language.new("Limburgan", :lim, :li),
        lin: Language.new("Lingala", :lin, :ln),
        lit: Language.new("Lithuanian", :lit, :lt),
        lol: Language.new("Mongo", :lol),
        loz: Language.new("Lozi", :loz),
        ltz: Language.new("Luxembourgish", :ltz, :lb),
        lua: Language.new("Luba-Lulua", :lua),
        lub: Language.new("Luba-Katanga", :lub, :lu),
        lug: Language.new("Ganda", :lug, :lg),
        lui: Language.new("Luiseno", :lui),
        lun: Language.new("Lunda", :lun),
        luo: Language.new("Luo (Kenya and Tanzania)", :luo),
        lus: Language.new("lushai", :lus),
        mac: Language.new("Macedonian", :mac, :mk),
        mad: Language.new("Madurese", :mad),
        mag: Language.new("Magahi", :mag),
        mah: Language.new("Marshallese", :mah, :mh),
        mai: Language.new("Maithili", :mai),
        mak: Language.new("Makasar", :mak),
        mal: Language.new("Malayalam", :mal, :ml),
        man: Language.new("Mandingo", :man),
        mao: Language.new("Maori", :mao, :mi),
        map: Language.new("Austronesian", :map),
        mar: Language.new("Marathi", :mar, :mr),
        mas: Language.new("Masai", :mas),
        may: Language.new("Malay", :may, :ms),
        mdf: Language.new("Moksha", :mdf),
        mdr: Language.new("Mandar", :mdr),
        men: Language.new("Mende", :men),
        mga: Language.new("Irish, Middle (900-1200)", :mga),
        mic: Language.new("Mi'kmaq", :mic),
        min: Language.new("Minangkabau", :min),
        mis: Language.new("Miscellaneous", :mis),
        mkh: Language.new("Mon-Khmer", :mkh),
        mlg: Language.new("Malagasy", :mlg, :mg),
        mlt: Language.new("Maltese", :mlt, :mt),
        mnc: Language.new("Manchu", :mnc),
        mni: Language.new("Manipuri", :mni, :ma),
        mno: Language.new("Manobo", :mno),
        moh: Language.new("Mohawk", :moh),
        mol: Language.new("Moldavian", :mol, :mo),
        mon: Language.new("Mongolian", :mon, :mn),
        mos: Language.new("Mossi", :mos),
        mwl: Language.new("Mirandese", :mwl),
        mul: Language.new("Multiple", :mul),
        mun: Language.new("Munda", :mun),
        mus: Language.new("Creek", :mus),
        mwr: Language.new("Marwari", :mwr),
        myn: Language.new("Mayan", :myn),
        myv: Language.new("Erzya", :myv),
        nah: Language.new("Nahuatl", :nah),
        nai: Language.new("North American Indian", :nai),
        nap: Language.new("Neapolitan", :nap),
        nau: Language.new("Nauru", :nau, :na),
        nav: Language.new("Navajo", :nav, :nv),
        nbl: Language.new("Ndebele, South", :nbl, :nr),
        nde: Language.new("Ndebele, North", :nde, :nd),
        ndo: Language.new("Ndonga", :ndo, :ng),
        nds: Language.new("Low German", :nds),
        nep: Language.new("Nepali", :nep, :ne),
        new: Language.new("Nepal Bhasa", :new),
        nia: Language.new("Nias", :nia),
        nic: Language.new("Niger-Kordofanian", :nic),
        niu: Language.new("Niuean", :niu),
        nno: Language.new("Norwegian Nynorsk", :nno, :nn),
        nob: Language.new("Norwegian Bokmal", :nob, :nb),
        nog: Language.new("Nogai", :nog),
        non: Language.new("Norse, Old", :non),
        nor: Language.new("Norwegian", :nor, :no),
        nso: Language.new("Northern Sotho", :nso),
        nub: Language.new("Nubian", :nub),
        nwc: Language.new("Classical Newari", :nwc),
        nya: Language.new("Chichewa", :nya, :ny),
        nym: Language.new("Nyamwezi", :nym),
        nyn: Language.new("Nyankole", :nyn),
        nyo: Language.new("Nyoro", :nyo),
        nzi: Language.new("Nzima", :nzi),
        oci: Language.new("Occitan", :oci, :oc),
        oji: Language.new("Ojibwa", :oji, :oj),
        ori: Language.new("Oriya", :ori, :or),
        orm: Language.new("Oromo", :orm, :om),
        osa: Language.new("Osage", :osa),
        oss: Language.new("Ossetian", :oss, :os),
        ota: Language.new("Turkish, Ottoman (1500-1928)", :ota),
        oto: Language.new("Otomian", :oto),
        paa: Language.new("Papuan", :paa),
        pag: Language.new("Pangasinan", :pag),
        pal: Language.new("Pahlavi", :pal),
        pam: Language.new("Pampanga", :pam),
        pan: Language.new("Panjabi", :pan, :pa),
        pap: Language.new("Papiamento", :pap),
        pau: Language.new("Palauan", :pau),
        peo: Language.new("Persian, Old (ca.600-400 B.C.)", :peo),
        per: Language.new("Persian", :per, :fa),
        phi: Language.new("Philippine", :phi),
        phn: Language.new("Phoenician", :phn),
        pli: Language.new("Pali", :pli, :pi),
        pol: Language.new("Polish", :pol, :pl),
        pon: Language.new("Pohnpeian", :pon),
        por: Language.new("Portuguese", :por, :pt),
        pra: Language.new("Prakrit", :pra),
        pro: Language.new("Provençal, Old (to 1500)", :pro),
        pus: Language.new("Pushto", :pus, :ps),
        que: Language.new("Quechua", :que, :qu),
        raj: Language.new("Rajasthani", :raj),
        rap: Language.new("Rapanui", :rap),
        rar: Language.new("Rarotongan", :rar),
        roa: Language.new("Romance", :roa),
        roh: Language.new("Raeto-Romance", :roh, :rm),
        rom: Language.new("Romany", :rom),
        run: Language.new("Rundi", :run, :rn),
        rup: Language.new("Aromanian", :rup),
        rus: Language.new("Russian", :rus, :ru),
        sad: Language.new("Sandawe", :sad),
        sag: Language.new("Sango", :sag, :sg),
        sah: Language.new("Yakut", :sah),
        sai: Language.new("South American Indian", :sai),
        sal: Language.new("Salishan", :sal),
        sam: Language.new("Samaritan Aramaic", :sam),
        san: Language.new("Sanskrit", :san, :sa),
        sas: Language.new("Sasak", :sas),
        sat: Language.new("Santali", :sat),
        scc: Language.new("Serbian", :scc, :sr),
        scn: Language.new("Sicilian", :scn),
        sco: Language.new("Scots", :sco),
        sel: Language.new("Selkup", :sel),
        sem: Language.new("Semitic", :sem),
        sga: Language.new("Irish, Old (to 900)", :sga),
        sgn: Language.new("Sign", :sgn),
        shn: Language.new("Shan", :shn),
        sid: Language.new("Sidamo", :sid),
        sin: Language.new("Sinhalese", :sin, :si),
        sio: Language.new("Siouan", :sio),
        sit: Language.new("Sino-Tibetan", :sit),
        sla: Language.new("Slavic", :sla),
        slo: Language.new("Slovak", :slo, :sk),
        slv: Language.new("Slovenian", :slv, :sl),
        sma: Language.new("Southern Sami", :sma),
        sme: Language.new("Northern Sami", :sme, :se),
        smi: Language.new("Sami languages", :smi),
        smj: Language.new("Lule Sami", :smj),
        smn: Language.new("Inari Sami", :smn),
        smo: Language.new("Samoan", :smo, :sm),
        sms: Language.new("Skolt Sami", :sms),
        sna: Language.new("Shona", :sna, :sn),
        snd: Language.new("Sindhi", :snd, :sd),
        snk: Language.new("Soninke", :snk),
        sog: Language.new("Sogdian", :sog),
        som: Language.new("Somali", :som, :so),
        son: Language.new("Songhai", :son),
        sot: Language.new("Sotho, Southern", :sot, :st),
        spa: Language.new("Spanish", :spa, :es),
        srd: Language.new("Sardinian", :srd, :sc),
        srr: Language.new("Serer", :srr),
        ssa: Language.new("Nilo-Saharan", :ssa),
        ssw: Language.new("Swati", :ssw, :ss),
        suk: Language.new("Sukuma", :suk),
        sun: Language.new("Sundanese", :sun, :su),
        sus: Language.new("Susu", :sus),
        sux: Language.new("Sumerian", :sux),
        swa: Language.new("Swahili", :swa, :sw),
        swe: Language.new("Swedish", :swe, :sv),
        syr: Language.new("Syriac", :syr, :sy),
        tah: Language.new("Tahitian", :tah, :ty),
        tai: Language.new("Tai", :tai),
        tam: Language.new("Tamil", :tam, :ta),
        tat: Language.new("Tatar", :tat, :tt),
        tel: Language.new("Telugu", :tel, :te),
        tem: Language.new("Timne", :tem),
        ter: Language.new("Tereno", :ter),
        tet: Language.new("Tetum", :tet),
        tgk: Language.new("Tajik", :tgk, :tg),
        tgl: Language.new("Tagalog", :tgl, :tl),
        tha: Language.new("Thai", :tha, :th),
        tib: Language.new("Tibetan", :tib, :bo),
        tig: Language.new("Tigre", :tig),
        tir: Language.new("Tigrinya", :tir, :ti),
        tiv: Language.new("Tiv", :tiv),
        tkl: Language.new("Tokelau", :tkl),
        tlh: Language.new("Klingon", :tlh),
        tli: Language.new("Tlingit", :tli),
        tmh: Language.new("Tamashek", :tmh),
        tog: Language.new("Tonga (Nyasa)", :tog),
        ton: Language.new("Tonga (Tonga Islands)", :ton, :to),
        tpi: Language.new("Tok Pisin", :tpi),
        tsi: Language.new("Tsimshian", :tsi),
        tsn: Language.new("Tswana", :tsn, :tn),
        tso: Language.new("Tsonga", :tso, :ts),
        tuk: Language.new("Turkmen", :tuk, :tk),
        tum: Language.new("Tumbuka", :tum),
        tup: Language.new("Tupi", :tup),
        tur: Language.new("Turkish", :tur, :tr),
        tut: Language.new("Altaic", :tut),
        tvl: Language.new("Tuvalu", :tvl),
        twi: Language.new("Twi", :twi, :tw),
        tyv: Language.new("Tuvinian", :tyv),
        udm: Language.new("Udmurt", :udm),
        uga: Language.new("Ugaritic", :uga),
        uig: Language.new("Uighur", :uig, :ug),
        ukr: Language.new("Ukrainian", :ukr, :uk),
        umb: Language.new("Umbundu", :umb),
        und: Language.new("Undetermined", :und),
        urd: Language.new("Urdu", :urd, :ur),
        uzb: Language.new("Uzbek", :uzb, :uz),
        vai: Language.new("Vai", :vai),
        ven: Language.new("Venda", :ven, :ve),
        vie: Language.new("Vietnamese", :vie, :vi),
        vol: Language.new("Volapük", :vol, :vo),
        vot: Language.new("Votic", :vot),
        wak: Language.new("Wakashan", :wak),
        wal: Language.new("Walamo", :wal),
        war: Language.new("Waray", :war),
        was: Language.new("Washo", :was),
        wel: Language.new("Welsh", :wel, :cy),
        wen: Language.new("Sorbian", :wen),
        wln: Language.new("Walloon", :wln, :wa),
        wol: Language.new("Wolof", :wol, :wo),
        xal: Language.new("Kalmyk", :xal),
        xho: Language.new("Xhosa", :xho, :xh),
        yao: Language.new("Yao", :yao),
        yap: Language.new("Yapese", :yap),
        yid: Language.new("Yiddish", :yid, :yi),
        yor: Language.new("Yoruba", :yor, :yo),
        ypk: Language.new("Yupik", :ypk),
        zap: Language.new("Zapotec", :zap),
        zen: Language.new("Zenaga", :zen),
        zha: Language.new("Zhuang", :zha, :za),
        znd: Language.new("Zande", :znd),
        zul: Language.new("Zulu", :zul, :zu),
        zun: Language.new("Zuni", :zun),
        rum: Language.new("Romanian", :rum, :ro),
        pob: Language.new("Portuguese (BR)", :pob, :pb),
        mne: Language.new("Montenegrin", :mne, :me),
        zht: Language.new("Chinese (traditional)", :zht, :zt),
        zhe: Language.new("Chinese bilingual", :zhe, :ze),
        pom: Language.new("Portuguese (MZ)", :pom, :pm),
        ext: Language.new("Extremaduran", :ext, :ex)
      }
    end

    ENGLISH = database[:eng]
    SPANISH = database[:spa]
    FRENCH = database[:fre]
    ITALIAN = database[:ita]
    SWEDISH = database[:swe]
    TURKISH = database[:tur]
    RUSSIAN = database[:rus]
    GREEK = database[:ell]
    DUTCH = database[:dut]
    PORTUGUESE = database[:por]
    CHINESE = database[:chi]
    JAPANESE = database[:jpn]
    GERMAN = database[:ger]
    ARABIC = database[:ara]
    ROMANIAN = database[:rum]
  end
end