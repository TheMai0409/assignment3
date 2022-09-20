// import 'package:assignment3/model/product_model.dart';
//
// final List<ProductModel> listProducts = [
//   ProductModel(
//       imageUrl:
//           "https://images.unsplash.com/photo-1445282768818-728615cc910a?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=870&q=80",
//       name: "Cà rốt",
//       description: "Cà rốt là một loại cây có củ, thường có màu đỏ, vàng, trắng hay tía. Phần ăn được của cà rốt là củ, thực chất là rễ cái của nó, chứa nhiều tiền tố của vitamin A tốt cho mắt",
//       isLiked: false,
//       cost: 50000,
//       id: '1',
//       category: 'vegetable'),
//   ProductModel(
//       imageUrl:
//           "https://images.unsplash.com/photo-1518977676601-b53f82aba655?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1170&q=80",
//       name: "Khoai tây",
//       description: "Khoai tây có chứa các vitamin, khoáng chất và một loạt các hóa chất thực vật như các carotenoit và phenol tự nhiên. Axít chlorogenic cấu thành đến 90% của phenol trong khoai tây.",
//       isLiked: false,
//       cost: 60000,
//       id: '2',
//       category: 'vegetable'),
//   ProductModel(
//       imageUrl:
//           "https://images.unsplash.com/photo-1524593166156-312f362cada0?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1170&q=80",
//       name: "Cà chua",
//       description: "Cà chua có chứa rất nhiều chất dinh dưỡng có lợi cho cơ thể như carotene, lycopene, vitamin và kali. Tất cả những chất này đều rất có lợi cho sức khoẻ con người. ",
//       isLiked: false,
//       cost: 70000,
//       id: '3',
//       category: 'vegetable'),
//   ProductModel(
//       imageUrl:
//           "https://images.unsplash.com/photo-1535041422672-8c3254ab3abe?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1yZWxhdGVkfDE0fHx8ZW58MHx8fHw%3D&auto=format&fit=crop&w=500&q=60",
//       name: "Ớt",
//       description: " Quả ớt dùng làm gia vị, thực phẩm vì chứa nhiều Vitamin A, Vitamin C gấp 5-10 hai loại sinh tố này có trong cà chua và cà rốt.",
//       isLiked: false,
//       cost: 40000,
//       id: '4',
//       category: 'vegetable'),
//   ProductModel(
//       imageUrl:
//           "https://images.unsplash.com/photo-1540148426945-6cf22a6b2383?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=870&q=80",
//       name: "Tỏi",
//       description: "Tỏi có thể sử dụng thành gia vị trong nước chấm pha chế gồm mắm, tỏi, ớt, tương, đường...Hoặc tỏi được trộn đều với các món rau xào (nhất là rau muống xào...) khiến món ăn dậy mùi thơm. Tỏi cũng được làm nước muối tỏi và ớt. Trong nấu ăn một số món có kèm theo tỏi phi.",
//       isLiked: false,
//       cost: 45000,
//       id: '5',
//       category: 'vegetable'),
//   ProductModel(
//       imageUrl:
//           "https://images.unsplash.com/photo-1518977956812-cd3dbadaaf31?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1170&q=80",
//       name: "Hành tây",
//       description: "Hành tây vừa được xem là một loại gia vị vừa như một loại rau rất giàu Kali, Selen, Vitamin C và Quercetin. Trong củ hành đỏ rất giàu các hợp chất và nhóm lưu huỳnh như DMS, DDS, DTS & DTTS gây mùi cay nồng.",
//       isLiked: false,
//       cost: 32000,
//       id: '6',
//       category: 'vegetable'),
//   ProductModel(
//       imageUrl:
//           "https://images.unsplash.com/uploads/141143339879512fe9b0d/f72e2c85?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=2070&q=80",
//       name: "Đậu cô ve",
//       description: "Quả đậu non, hay đậu non, là quả đậu chưa chín (unripe), chưa tách vỏ và được thu hoạch khi chưa trưởng thành (immature) hay còn non của các giống cây trồng các loài đậu có vỏ Phaseolus vulgaris",
//       isLiked: false,
//       cost: 60000,
//       id: '7',
//       category: 'vegetable'),
//   ProductModel(
//       imageUrl:
//           "https://images.unsplash.com/photo-1425543103986-22abb7d7e8d2?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=2070&q=80",
//       name: "Đậu bắp",
//       description: "Đậu bắp còn có các tên khác như mướp tây, bắp còi và gôm, còn được biết đến ở các quốc gia nói tiếng Anh là móng tay phụ nữ. Đây là một loài thực vật có hoa có giá trị vì quả non ăn được.",
//       isLiked: false,
//       cost: 55000,
//       id: '8',
//       category: 'vegetable'),
//   ProductModel(
//       imageUrl:
//           "https://images.unsplash.com/photo-1449300079323-02e209d9d3a6?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=774&q=80",
//       name: "Dưa chuột",
//       description: "Dưa chuột là một cây trồng phổ biến trong họ bầu bí, là loại rau ăn quả thương mại quan trọng, nó được trồng lâu đời trên thế giới và trở thành thực phẩm của nhiều nước.",
//       isLiked: false,
//       cost: 35000,
//       id: '9',
//       category: 'vegetable'),
//   ProductModel(
//       imageUrl:
//           "https://images.unsplash.com/photo-1499125562588-29fb8a56b5d5?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1332&q=80",
//       name: "Cá hồi",
//       description: "Cá hồi là tên chung cho nhiều loài cá thuộc họ Salmonidae",
//       isLiked: false,
//       cost: 35000,
//       id: '10',
//       category: 'meat'),
//   ProductModel(
//       imageUrl:
//           "https://images.unsplash.com/photo-1568727349390-7deb45c78797?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1170&q=80",
//       name: "Cá xám",
//       description: "Cá tươi ngon",
//       isLiked: false,
//       cost: 35000,
//       id: '11',
//       category: 'meat'),
//   ProductModel(
//       imageUrl:
//           "https://images.unsplash.com/photo-1603048297172-c92544798d5a?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1yZWxhdGVkfDJ8fHxlbnwwfHx8fA%3D%3D&auto=format&fit=crop&w=500&q=60",
//       name: "Thịt bò",
//       description: "Thịt bò là thịt của con bò (thông dụng là loại bò thịt). Đây là thực phẩm gia súc phổ biến trên thế giới, cùng với thịt lợn, được chế biến và sử dụng theo nhiều cách, trong nhiều nền văn hoá và tôn giáo khác nhau, cùng với thịt lợn và thịt gà, thịt bò là một trong những loại thịt được con người sử dụng nhiều nhất.",
//       isLiked: false,
//       cost: 35000,
//       id: '12',
//       category: 'meat'),
//   ProductModel(
//       imageUrl:
//           "https://images.unsplash.com/photo-1628268909376-e8c44bb3153f?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1170&q=80",
//       name: "Thịt lợn",
//       description: "Thịt lợn hay thịt heo là thịt từ heo, là một loại thực phẩm rất phổ biến trên thế giới, tiêu thụ thịt heo của người Việt chiếm tới 73,3%, thịt gia cầm là 17,5% và chỉ 9,2% còn lại là thịt các loại, điều này xuất phát từ truyền thống ẩm thực của người Việt thường ăn thịt heo và thịt gà nhiều hơn các loại thịt khác.",
//       isLiked: false,
//       cost: 35000,
//       id: '13',
//       category: 'meat'),
//   ProductModel(
//       imageUrl:
//           "http://t1.gstatic.com/licensed-image?q=tbn:ANd9GcRjwjoI1sW2T1jmcmXyjsiXU4fSthUSglrV58p0BfCGiLvdh_lCUliXXtN2gjnTTNnHJ0rmK4PVz25ShMuYSF4",
//       name: "Thịt cừu",
//       description: "Thịt cừu hay thịt trừu là loại thịt thực phẩm từ cừu. Ở một số quốc gia, thịt cừu không những tốt cho sức khỏe mà được coi là món ăn mang lại sự may mắn và sung túc cho người được thưởng thức. Việc tiêu thụ nhiều thịt cừu góp phần thúc đẩy ngành chăn nuôi cừu",
//       isLiked: false,
//       cost: 35000,
//       id: '14',
//       category: 'meat'),
//   ProductModel(
//       imageUrl:
//           "https://images.unsplash.com/photo-1547050605-2f268cd5daf0?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1yZWxhdGVkfDJ8fHxlbnwwfHx8fA%3D%3D&auto=format&fit=crop&w=500&q=60",
//       name: "Thịt trâu",
//       description: "Thịt trâu là thịt của các loài trâu nhà. Thịt trâu là nguồn thực phẩm quan trọng đối với các cư dân vùng Nam Á và Đông Nam Á nơi người ta nuôi trâu phổ biến.",
//       isLiked: false,
//       cost: 35000,
//       id: '15',
//       category: 'meat'),
//   ProductModel(
//       imageUrl:
//           "https://images.unsplash.com/photo-1535424921017-85119f91e5a1?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1170&q=80",
//       name: "Cá",
//       description: "Cá biển tươi ngon",
//       isLiked: false,
//       cost: 35000,
//       id: '16',
//       category: 'meat'),
//   ProductModel(
//       imageUrl:
//           "https://images.unsplash.com/photo-1551463682-189bf47449d0?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=796&q=80",
//       name: "Tôm hùm",
//       description: "Tôm hùm càng là tên gọi dùng để chỉ một họ chứa các loài tôm hùm. Họ Tôm hùm càng có đặc điểm gồm thân dài và có một cái đuôi cơ bắp, hầu hết họ tôm hùm này đều có một đôi càng lớn và đầy sức mạnh",
//       isLiked: false,
//       cost: 35000,
//       id: '17',
//       category: 'meat'),
//   ProductModel(
//       imageUrl:
//           "https://haisantrungnam.vn/wp-content/uploads/2020/03/cua-hoang-de-king-crab-cua-huynh-de-cua-alaska-2-600x331.jpg",
//       name: "Cua biển",
//       description: "Cua hay cua thực sự là nhóm chứa các loài động vật giáp xác, thân rộng hơn bề dài, mai mềm, mười chân có khớp, hai chân trước tiến hóa trở thành hai càng, vỏ xương bọc ngoài thịt, phần bụng nằm bẹp dưới hoàn toàn được che bởi phần ngực. Động vật dạng cua có nhiều tại tất cả các vùng biển, đại dương",
//       isLiked: false,
//       cost: 35000,
//       id: '18',
//       category: 'meat'),
//   ProductModel(
//       imageUrl:
//           "https://images.unsplash.com/photo-1624031000828-dba1b7a3e4ce?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1170&q=80",
//       name: "Chảo",
//       description: "Chảo siêu chống dính",
//       isLiked: false,
//       cost: 120000,
//       id: '19',
//       category: 'houseware'),
//   ProductModel(
//       imageUrl:
//           "https://images.unsplash.com/photo-1588279102567-67db026f11c0?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1yZWxhdGVkfDN8fHxlbnwwfHx8fA%3D%3D&auto=format&fit=crop&w=500&q=60",
//       name: "Xong",
//       description: "Xong siêu bền",
//       isLiked: false,
//       cost: 55000,
//       id: '20',
//       category: 'houseware'),
//   ProductModel(
//       imageUrl:
//           "https://images.unsplash.com/photo-1602063238855-524c4d8b9b18?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTB8fGtuaWZlfGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=500&q=60",
//       name: "Dao",
//       description: "Bộ dao siêu sắc",
//       isLiked: false,
//       cost: 60000,
//       id: '21',
//       category: 'houseware'),
//   ProductModel(
//       imageUrl:
//           "https://images.unsplash.com/photo-1495130656884-992a9f30d178?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8NXx8Y2hvcHBpbmclMjBib2FyZHxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=500&q=60",
//       name: "Thớt",
//       description: "Thớt không lưu lại vết dao",
//       isLiked: false,
//       cost: 90000,
//       id: '22',
//       category: 'houseware'),
//   ProductModel(
//       imageUrl:
//           "https://images.unsplash.com/photo-1552940661-f6e181c4e0c0?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTN8fHNwaWNlJTIwamFyfGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=500&q=60",
//       name: "Lọ gia vị",
//       description: "Bảo quản gia vị lâu dài",
//       isLiked: false,
//       cost: 40000,
//       id: '23',
//       category: 'houseware'),
//   ProductModel(
//       imageUrl:
//           "https://images.unsplash.com/photo-1536000800373-5b5e6020910a?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1yZWxhdGVkfDEzfHx8ZW58MHx8fHw%3D&auto=format&fit=crop&w=500&q=60",
//       name: "Thìa",
//       description: "Thìa gỗ từ thiên nhiên",
//       isLiked: false,
//       cost: 60000,
//       id: '24',
//       category: 'houseware'),
//   ProductModel(
//       imageUrl:
//           "https://images.unsplash.com/photo-1551807306-4bcd16b92a41?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1170&q=80",
//       name: "Đĩa ",
//       description: "Đĩa dơi không vỡ",
//       isLiked: false,
//       cost: 35000,
//       id: '25',
//       category: 'houseware'),
//   ProductModel(
//       imageUrl:
//           "https://images.unsplash.com/photo-1574269909862-7e1d70bb8078?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1176&q=80",
//       name: "Lò vi sóng",
//       description: "Làm nóng thức ăn nhanh hơn bao giờ hết",
//       isLiked: false,
//       cost: 2000000,
//       id: '26',
//       category: 'houseware'),
//   ProductModel(
//       imageUrl:
//           "https://images.unsplash.com/photo-1584269600519-112d071b35e6?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1yZWxhdGVkfDN8fHxlbnwwfHx8fA%3D%3D&auto=format&fit=crop&w=500&q=60",
//       name: "Lò nướng",
//       description: "Làm chín thức ăn nhanh hơn, tiện lợi hơn",
//       isLiked: false,
//       cost: 5000000,
//       id: '27',
//       category: 'houseware'),
// ];
