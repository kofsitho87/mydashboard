import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/blocs.dart';
import '../models/models.dart';

class AddCategoryApp extends StatelessWidget {
  final Category currentCategory;
  AddCategoryApp({this.currentCategory});

  CategoriesBloc category_bloc;
  BuildContext context;

  final categoryController = TextEditingController();

  void _addCategoryEvent() {
    final category = Category('', categoryController.text);
    this.category_bloc.dispatch(AddCategory(category));
  }

  void _updateCategoryEvent(){
    if( categoryController.text == currentCategory.title ){
      Navigator.of(context).pop();
      return;
    }
    final category = currentCategory;
    category.title = categoryController.text;
    this.category_bloc.dispatch(UpdatedCategory(category));
  }

  Widget get formView {
    return Form(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            TextFormField(
              autofocus: true,
              controller: categoryController,
              onEditingComplete: () {
                if( categoryController.text.length > 0 ){
                  currentCategory == null ? _addCategoryEvent() : _updateCategoryEvent();
                }
                //Navigator.of(context).pop();
              },
              autocorrect: false,
              decoration: InputDecoration(
                labelText: '카테고리 이름',
                //labelStyle: TextStyle(color: Colors.white)
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget get headerView {
    return Container(
      padding: EdgeInsets.only(
        top: 20,
        left: 20,
        right: 20,
        bottom: 20,
      ),
      child: Row(
        children: <Widget>[
          // IconButton(
          //   icon: Icon(
          //     Icons.close,
          //     //color: Colors.white
          //   ),
          //   onPressed: () => Navigator.of(context).pop(),
          // ),
          Text('카테고리 ${currentCategory != null ? '수정' : '추가'}',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                //color: Colors.white
              ))
        ],
      ),
    );
  }

  Widget get bodyView {
    return Column(
      children: <Widget>[
        headerView,
        formView
      ],
    );
  }

  Widget get containerView {
    return Container(
      padding: EdgeInsets.only(top: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          // Where the linear gradient begins and ends
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          // Add one stop for each color. Stops should increase from 0 to 1
          stops: [0, 0.7],
          colors: [
            Color.fromRGBO(209, 126, 242, 0.69),
            Color.fromRGBO(129, 92, 206, 1)
          ],
        ),
      ),
      child: bodyView,
    );
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;
    this.category_bloc = BlocProvider.of<CategoriesBloc>(context);

    if(currentCategory != null){
      categoryController.text = currentCategory.title;
    }

    return Scaffold(
        // appBar: AppBar(
        //   backgroundColor: Color.fromRGBO(209, 126, 242, 0.69),
        //   centerTitle: false,
        //   title: Text('카테고리 추가'),
        //   leading: IconButton(
        //     icon: Icon(Icons.close),
        //     onPressed: () => Navigator.of(context).pop(),
        //   ),
        // ),
        body: BlocListener(
      bloc: category_bloc,
      listener: (listenerContext, state) {
        if (state is SuccessAddCategory) {
          Navigator.of(context).pop();
        }
      },
      child: bodyView,
    ));
  }
}
