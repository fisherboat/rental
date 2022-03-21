## 系统设计
### 技术选型
1. Web框架用rails
2. 数据库用postgresql
3. Json builder用Rabl
### 重点技术问题
1. 检索书会用到模糊查找，书库比较大时查询效率会比较低，即使加了索引效果也不太理想，故用Gin替换默认的Btree
2. 借还书时涉及到修改库存，在高并发的场景下会有数据不一致的问题，故使用`with_lock`锁行的方法解决高并发问题
3. 关于库存问题，每次借还书系统自动添加一条租赁记录(Rental record), 之后将借还次数放写到book表中来快速判断书的库存
4. 为了保证接口安全在请求header中添加签名

### 使用到的表
* users: 用户信息
* books: 书籍信息
* rental_records: 借还记录表

## 接口文档

API接口基本路径：
```
https:murmuring-bayou-58304.herokuapp.com/api
```

### 创建用户
POST /users

参数

|参数名|类型|描述|是否必填|
|:----:|:----:|:----:|----:|
|name|String|用户名|是|
|email|String|用户邮件|是|

返回:

用户基本信息

例如
```json
{
  "id": 2,
  "name": "fisherboat",
  "email": "fisherboat@gmail.com"
}
```

### 创建用户
POST /users/{id}

参数

|参数名|类型|描述|是否必填|
|:----:|:----:|:----:|----:|
|id|Ingeter|用户ID|是|

返回:

用户基本所有信息

例如：
```json
{
  "id": 2,
  "name": "fisherboat",
  "email": "fisherboat@gmail.com",
  "balance": 76.0,
  "books": [
    {
      "id": 5,
      "name": "No Highway",
      "price": "56.0"
    }
  ]
}
```
### 获取书列表
GET /books

参数：
|参数名|类型|描述|是否必填|
|:----:|:----:|:----:|----:|
|name|String|按名称模糊搜索书|否|
|page|Integer|分页页码|否|

返回:

书列表和分页信息

例如
```json
{
  "books": [
    {
      "id": 2,
      "name": "Ruby 原理剖析",
      "borrow_times": 0,
      "repay_times": 0,
      "price": 10.0
    }
  ],
  "pageination": {
    "total_count": 3,
    "total_pages": 1,
    "current_page": 1,
    "next_page": null,
    "prev_page": null,
    "is_first_page": true,
    "is_last_page": true
  }
}
```

### 获取书详细信息
GET /books/{id}

参数：
|参数名|类型|描述|是否必填|
|:----:|:----:|:----:|----:|
|id|Integer|书ID|是|

返回:

书详细信息

例如
```json
{
  "id": 5,
  "name": "No Highway",
  "borrow_times": 5,
  "repay_times": 4,
  "stock": 20,
  "price": 56.0,
  "remaining_stock": 19
}
```

### 获取书实际收益
GET /books/{id}/actual_income

参数：
|参数名|类型|描述|是否必填|
|:----:|:----:|:----:|----:|
|id|Integer|书ID|是|

返回:

书的实际收益

例如
```json
{
  "actual_income": 224.0
}
```

### 借书
GET /books/{id}/borrow

参数：
|参数名|类型|描述|是否必填|
|:----:|:----:|:----:|----:|
|id|Integer|书ID|是|
|user_id|Integer|用户ID|是|

返回:

成功和失败的信息

成功例如
```json
{
  "message": "Borrow book success"
}
```

### 归还
GET /books/{id}/borrow

参数：
|参数名|类型|描述|是否必填|
|:----:|:----:|:----:|----:|
|id|Integer|书ID|是|
|user_id|Integer|用户ID|是|

返回:

成功和失败的信息

成功例如
```json
{
  "message": "Repay book success"
}
```

### 成功和失败说明
#### 成功后有两种放回的数据格式
1. 放回操作成功信息，示例如下：
```json
{
  "message": "Repay book success"
}
```
2. 放回具体数据，示例如下：
```json
{
  "id": 5,
  "name": "No Highway",
  "borrow_times": 5,
  "repay_times": 4,
  "stock": 20,
  "price": 56.0,
  "remaining_stock": 19
}
```
#### 失败后放回数据数据格式
1. 直接返回错误信息， 示例如下：
```json
{
  "errors": "Not find record"
}
```
2. 放回错误信息和集体的字段
```json
{
  "errors": {
    "book_id": "Book cannot be replied"
  }
}
```





