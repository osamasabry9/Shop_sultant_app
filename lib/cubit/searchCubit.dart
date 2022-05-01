import 'package:Shopsultant/cubit/states.dart';
import 'package:Shopsultant/models/searchModel/searchModel.dart';
import 'package:Shopsultant/remoteNetwork/dioHelper.dart';
import 'package:Shopsultant/remoteNetwork/endPoints.dart';
import 'package:Shopsultant/shared/constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class SearchCubit extends Cubit<ShopStates> {
  SearchCubit() : super(InitialState());

  static SearchCubit get(context) => BlocProvider.of(context);

  SearchModel? searchModel;
  void getSearchData(String searchText){
    emit(SearchLoadingState());
    DioHelper.postData(
        url: SEARCH,
        token: token,
        data: {
          'text':'$searchText',
        }
    ).then((value){
      searchModel = SearchModel.fromJson(value.data);
      print('Search '+searchModel!.status.toString());
      emit(SearchSuccessState());
    }).catchError((error){
      emit(SearchErrorState());
      print(error.toString());
    });
  }
}