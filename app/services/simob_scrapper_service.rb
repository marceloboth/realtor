class SimobScrapperService
  include CallableService

  REAL_STATES = {
    habiteto: {
      url: 'https://sahabiteto.simob.com.br/v2/integracaoApi/imovel/filtro/categoria/caracteristicas',
      token: '01373e76de01e69c87bbe37872ae63d6',
      payload: '{"data":"{\"idsCategorias\":[19],\"finalidade\":1,\"ceps\":[\"SÃO MIGUEL DO OESTE\"],\"idsBairros\":[],\"rangeValue\":{\"min\":\"\",\"max\":\"\"},\"caracteristicas\":[],\"selectedOptions\":{\"categorias\":[{\"id\":19,\"descricao\":\"Casa de Alvenaria \",\"count\":6,\"idsImoveis\":\"894,949,970,3492,4049,4051\"}],\"caracteristicas\":[],\"bairros\":[],\"cidades\":[{\"cidade\":\"SÃO MIGUEL DO OESTE\",\"uf\":\"SC\",\"count\":70,\"idsImoveis\":\"4052,4051,4048,4044,4043,4042,4041,4016,4014,4013,4008,4005,4002,4001,4000,3994,3935,3932,3929,3706,3518,3517,3511,3412,3395,3381,3210,3200,3155,3124,3097,2678,2648,2645,2566,2559,2253,2072,1978,1824,1713,1698,1344,1305,1289,1148,970,894,800,707,599,548,546,437,279,254,177,79,2610,828,1287,949,4038,1744,3437,3492,3584,3905,4037,4049\",\"idsCategorias\":\"35,17,27,25,19,26,24,31\"}],\"finalidade\":\"Alugar\",\"range\":{\"maxRange\":\"\",\"minRange\":\"\"}},\"offset\":{\"maxResults\":12,\"firstResult\":0},\"acuracidade\":100,\"countResults\":false,\"considerarPrevisaoSaida\":false,\"calcularValorAbono\":false,\"orderBy\":[{\"sort\":\"valor\",\"descricao\":\"Valor\",\"order\":\"asc\",\"active\":false,\"type\":\"number\"},{\"sort\":\"metrica\",\"order\":\"desc\"}],\"trazerCaracteristicas\":3}"}',
      website: 'https://habiteto.com.br/.com.br'
    },
    piovesan: {
      url: 'https://ipiovesan.simob.com.br/v2/integracaoApi/imovel/filtro/categoria/caracteristicas',
      token: '0e6ffdd8bca40773aa6abb5f795173af',
      payload: nil,
      website: 'https://piovesanimobiliaria.com.br/'
    },
    guisti: {
      url: 'https://simob.com.br/v2/integracaoApi/imovel/filtro/categoria/caracteristicas',
      token: 'f8cf9171be43915263ed8b4b358608fa',
      payload: nil,
      website: 'https://imobiliariagiusti.com.br/'
    },
    imobiliaria_facil: {
      url: 'https://simob.com.br/v2/integracaoApi/imovel/filtro/categoria/caracteristicas',
      token: 'ade9126003d71320146a0700b1a62a31',
      payload: nil,
      website: 'https://imobiliariafacilsmo.com.br/'
    },
    investir_empreendimentos: {
      url: 'https://simob.com.br/v2/integracaoApi/imovel/filtro/categoria/caracteristicas',
      token: 'caba326ede3fc8ef2a0444316778cc83',
      payload: '{"data":"{\"idsCategorias\":[4781],\"finalidade\":1,\"ceps\":[\"SÃO MIGUEL DO OESTE\"],\"idsBairros\":[],\"rangeValue\":{\"min\":0,\"max\":\"\"},\"caracteristicas\":[{\"id\":30603,\"idTipoCaracteristica\":3,\"qtd\":0,\"considerarValorExato\":false},{\"id\":30604,\"idTipoCaracteristica\":3,\"qtd\":0,\"considerarValorExato\":false},{\"id\":32515,\"idTipoCaracteristica\":3,\"qtd\":0,\"considerarValorExato\":false}],\"offset\":{\"maxResults\":12,\"firstResult\":0},\"acuracidade\":100,\"countResults\":false,\"considerarPrevisaoSaida\":0,\"calcularValorAbono\":false,\"orderBy\":[{\"sort\":\"valor\",\"descricao\":\"Valor\",\"order\":\"desc\",\"active\":false,\"type\":\"number\"}],\"trazerCaracteristicas\":3}"',
      website: 'https://investirempreendimentos.com.br'
    },
  }.freeze

  def call
    REAL_STATES.each_pair do |key, value|
      scrap_real_state(name: key.to_s.humanize, data: value)
    end
  end

  def scrap_real_state(name:, data:)
    url = data[:url]
    conn = Faraday.new do |f|
      f.request :authorization, 'Bearer', data[:token]
    end

    extract_from_simob(conn, url, payload: data[:payload], real_state: name, website: data[:website])
  end

  def extract_from_simob(conn, url, real_state:, website:, payload: nil)
    parsed_response = conn.post(
      url,
      payload || '{"data":"{\"idsCategorias\":[2875],\"finalidade\":1,\"ceps\":[\"SÃO MIGUEL DO OESTE\"],\"idsBairros\":[],\"rangeValue\":{\"min\":0,\"max\":\"\"},\"caracteristicas\":[{\"id\":7205,\"idTipoCaracteristica\":3,\"qtd\":0,\"considerarValorExato\":true},{\"id\":7162,\"idTipoCaracteristica\":3,\"qtd\":0,\"considerarValorExato\":true},{\"id\":7161,\"idTipoCaracteristica\":3,\"qtd\":0,\"considerarValorExato\":true}],\"offset\":{\"maxResults\":12,\"firstResult\":0},\"acuracidade\":100,\"countResults\":false,\"considerarPrevisaoSaida\":0,\"calcularValorAbono\":false,\"orderBy\":[{\"sort\":\"valor\",\"descricao\":\"Valor\",\"order\":\"asc\",\"active\":false,\"type\":\"number\"},{\"sort\":\"metrica\",\"order\":\"desc\"}],\"trazerCaracteristicas\":3}"}',
      'Content-Type' => 'application/json'
    )

    return [] if parsed_response.status == 500

    houses_items = JSON.parse(parsed_response.body)['result'] || []
    extracted_houses = houses_items.map do |house|
      {
        bathrooms: house['caracteristicas'][1]['valor'],
        bedrooms: house['caracteristicas'][0]['valor'],
        price: house['valor'].to_f,
        address: "#{house['endereco']} #{house['bairro']}",
        real_state:,
        origin_url: house_website_url(website, house),
        image: image_url(real_state, house)
      }
    end

    # House.upsert_all(extracted_houses, unique_by: :address)
    House.where(real_state:).delete_all
    House.create!(extracted_houses)
  rescue StandardError
    Rails.logger.info ">>>> Connection problems with #{real_state}"
  end

  private

  def house_website_url(website, house)
    "#{website}/imovel/exibir/locacao-casa-#{house['bairro']}-sao-miguel-do-oeste/#{house['codigo']}"
  end

  def image_url(real_state, house)
    if real_state == 'Piovesan'
      "https://ipiovesan.simob.com.br/#{house['baseUrlImagem']}/#{house['imagem']}"
    else
      "https://simob.com.br/#{house['baseUrlImagem']}/#{house['imagem']}"
    end
  end
end
