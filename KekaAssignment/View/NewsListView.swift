//
//  NewListView.swift
//  KekaAssignment
//
//  Created by Shaikh Rakib on 16/04/24.
//

import SwiftUI

struct NewsListView: View {
    @StateObject  var viewModel: NewListViewModel<NewsDataFetcher, NewsDataStorer>

    init() {
        let dataFetcher = NewsDataFetcher()
        let dataStorer = NewsDataStorer()
        let interactor = NewsViewModelInteractor(dataFetcher: dataFetcher, dataStorer: dataStorer)
        self._viewModel = StateObject(wrappedValue: NewListViewModel(interactor: interactor))
    }
    
    var body: some View {
        NavigationStack {
            List(viewModel.sortedNews, id: \.id) { news in
                HStack(alignment: .top) {
                    //MARK: Out of the box url is not working did this after some research not a good approad
                    AsyncImage(url: URL(string: ("https://static01.nyt.com/" + (news.photoUrl ?? "")))) { image in
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: 100, height: 100)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    } placeholder: {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(.gray)
                            .frame(width: 100, height: 100)
                    }

                    VStack(alignment: .leading) {
                        Text(news.headline ?? "")
                            .bold()
                        Text(news.pubDate?.formatted(date: .abbreviated, time: .omitted) ?? "")
                            .font(.footnote)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .navigationTitle("News")
            .onAppear {
                viewModel.fetchNews()
            }
        }
    }
}

#Preview {
    NewsListView()
}



