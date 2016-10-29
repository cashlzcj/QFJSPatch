require('YHRefreshTitleView, UIColor, JPObject, XNBaseTableViewCell');
defineClass('HomePageVC', {
    setRefresh: function() {
        var slf = self;
        self.setRefreshTitleView(YHRefreshTitleView.viewWithTitle_scrollView_refreshing("hello world", self.tableView(), block('YHRefreshTitleView*', function(view) {
            slf.query();
        })));
        self.refreshTitleView().trigger();
        self.navigationItem().setTitleView(self.refreshTitleView());

    },
});

defineClass('HomePageCell', {
    cellDicts: function() {
      var dict = JPObject.dict()
      var dict1 = JPObject.dict()
      dict1.setObject_forKey("LoanProduct_WorkerLoan", "imageName");
      dict1.setObject_forKey("recommendTag", "tagImageName");
      dict1.setObject_forKey("热门产品", "tagText");
      dict1.setObject_forKey(UIColor.colorWithRed_green_blue_alpha(1.00, 0.70, 0.40, 1.00), "topViewColor");
      dict.setObject_forKey(dict1,1)

      var dict2 = JPObject.dict()
      dict2.setObject_forKey("LoanProduct_StudentLoan","imageName");
      dict2.setObject_forKey("tagImageName","hotTag");
      dict2.setObject_forKey("一点也不急速","tagText");
      dict2.setObject_forKey("UIColor.colorWithRed_green_blue_alpha(0.58, 0.72, 0.90, 1.00)","tagText");
      dict.setObject_forKey(dict2, 2);

      var dict3 = JPObject.dict();
       dict3.setObject_forKey("LoanProductIcon_FastLoan","imageName");
      dict3.setObject_forKey("tagImageName","hotTag");
      dict3.setObject_forKey("一点也不急速","tagText");
      dict3.setObject_forKey("UIColor.colorWithRed_green_blue_alpha(0.58, 0.72, 0.90, 1.00)","tagText");
      dict3.setObject_forKey(dict3, 3);

      return dict.toJS();
    },
});