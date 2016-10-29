require('UIViewController, UILabel, UIColor')
defineClass('ViewController: UIViewController', {
    setLabelText: function(){
      self.lbText().setText("1000");
    },

    viewDidLoad: function(){
      self.ORIGviewDidLoad();
      self.setLabelText();
      var view = self.view();
      view.setBackgroundColor(UIColor.redColor());
    }
  }
);

