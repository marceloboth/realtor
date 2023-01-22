class ScrapSimobRealStatesWorker
  include Sidekiq::Worker

  def perform(payload)
    name, data = payload

    url = data[:url]
    conn = Faraday.new do |f|
      f.request :authorization, 'Bearer', data[:token]
    end

    extract_from_simob(conn, url, payload: data[:payload], real_state: name, website: data[:website])
  end

  private

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
