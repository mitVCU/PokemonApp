import SwiftUI

struct ContentView: View {
    @State var pokemonList: PokemonList? = nil
    @State var poke: [String: String] = [:]

    var body: some View {
        List(Array(pokemonList?.results ?? []), id: \.name) { pokemon in
            
            HStack {
                if let sprite = poke[pokemon.url] {
                    AsyncImage(url: URL(string: sprite))
                }
                
                Text(pokemon.name)
                    .task {
                        do {
                            let pokemonURLReq = URLRequest(url: URL(string: pokemon.url)!)
                            
                            if poke[pokemon.url] == nil {
                                let pokemonDetails = try await APIClient().fetch(url: pokemonURLReq, type: Pokemon.self)
                                poke[pokemon.url] = pokemonDetails.sprites.front_default
                            }
                        } catch { }
                    }
            }
        }
        .task {
            do {
                let listEndpoint = try PokemonListEndpoint().makeRequest()
                
                let list = try await APIClient().fetch(url: listEndpoint, type: PokemonList.self)
                pokemonList = list
                
                
                
                
            } catch { }
        }
        

    }
}

#Preview {
    ContentView()
}
