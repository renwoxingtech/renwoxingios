//
//  DataModel.h
//  CommonProject
//
//  Created by mac on 2016/12/27.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface DataModel : NSObject

@end

@interface TrainStation : DataModel
@property (nonatomic,copy)NSString *code;
@property (nonatomic,copy)NSString *name;
@property (nonatomic,copy)NSString *szm;
@property (nonatomic,copy)NSString *pinyin;


@end


@interface CheCiRes : DataModel
@property(nonatomic,assign)BOOL isChoosed;
@property(nonatomic,retain) NSArray *seatTypeArr;

@property(nonatomic,retain) NSArray *zuoweiNumArr;
@property(nonatomic,retain) NSArray *zuoweiPirceArr;

@property(nonatomic,retain) NSString *train_no;
@property(nonatomic,retain) NSString *arrive_days;
@property(nonatomic,retain) NSString *arrive_time;
@property(nonatomic,retain) NSString *ydz_num;
@property(nonatomic,retain) NSString *train_code;
@property(nonatomic,retain) NSString *start_station_name;
@property(nonatomic,retain) NSString *ydz_price;
@property(nonatomic,retain) NSString *yz_num;
@property(nonatomic,retain) NSString *gjrw_price;
@property(nonatomic,retain) NSString *tdz_price;
@property(nonatomic,retain) NSString *wz_price;
@property(nonatomic,retain) NSString *gjrw_num;
@property(nonatomic,retain) NSString *to_station_code;
@property(nonatomic,retain) NSString *from_station_code;
@property(nonatomic,retain) NSString *rz_num;
@property(nonatomic,retain) NSString *run_time_minute;
@property(nonatomic,retain) NSString *ywx_price;
@property(nonatomic,retain) NSString *edz_price;
@property(nonatomic,retain) NSString *tdz_num;
@property(nonatomic,retain) NSString *rw_price;
@property(nonatomic,retain) NSString *rz_price;
@property(nonatomic,retain) NSString *sale_date_time;
@property(nonatomic,retain) NSString *run_time;
@property(nonatomic,retain) NSString *distance;
@property(nonatomic,retain) NSString *edz_num;
@property(nonatomic,retain) NSString *to_station_name;
@property(nonatomic,retain) NSString *ywz_price;
@property(nonatomic,retain) NSString *yw_num;
@property(nonatomic,retain) NSString *can_buy_now;
@property(nonatomic,retain) NSString *yw_price;
@property(nonatomic,retain) NSString *yz_price;
@property(nonatomic,retain) NSString *gjrws_price;
@property(nonatomic,retain) NSString *qtxb_price;
@property(nonatomic,retain) NSString *rwx_price;
@property(nonatomic,retain) NSString *access_byidcard;
@property(nonatomic,retain) NSString *from_station_name;
@property(nonatomic,retain) NSString *start_time;
@property(nonatomic,retain) NSString *end_station_name;
@property(nonatomic,retain) NSString *rw_num;
@property(nonatomic,retain) NSString *train_type;
@property(nonatomic,retain) NSString *wz_num;
@property(nonatomic,retain) NSString *qtxb_num;
@property(nonatomic,retain) NSString *swz_price;
@property(nonatomic,retain) NSString *swz_num;
@property(nonatomic,retain) NSString *train_start_date;
@property(nonatomic,retain) NSString *note;
@property(nonatomic,copy)   NSString *yushouriqi;

@end


@interface UserInfo  : DataModel
@property(nonatomic,retain) NSString *take_province;
@property(nonatomic,retain) NSString *take_county;
@property(nonatomic,retain) NSString *phone;
@property(nonatomic,retain) NSString *take_uname;
@property(nonatomic,retain) NSString *take_city;
@property(nonatomic,retain) NSString *take_address;
@property(nonatomic,retain) NSString *balance;
@property(nonatomic,retain) NSString *take_phone;
@property(nonatomic,retain) NSString *income;
@property(nonatomic,retain) NSString *regtime;
@property(nonatomic,retain) NSString *account;
@property(nonatomic,retain) NSString *take_pcc;

@end

@interface DateObject : DataModel

@property(nonatomic,retain) NSString *originalStr;
@property(nonatomic,retain) NSString *showStr;
@property(nonatomic,assign) BOOL isSelect;

@end


@interface Customer : DataModel<NSCopying,NSMutableCopying>


@property(nonatomic,copy) NSString *name;
@property(nonatomic,copy) NSString *id_number;
@property(nonatomic,assign) BOOL isSelect;
@property(nonatomic,assign) BOOL isXs;
@property(nonatomic,retain) NSString *person_id;
@property(nonatomic,retain) NSString *passengerid;
@property(nonatomic,assign) NSInteger type;
@property(nonatomic,retain) NSString *type_name;
@property(nonatomic,retain) NSString *id_imgurl;

@property(nonatomic,assign) NSInteger id_type;
@property(nonatomic,copy) NSString *id_name;
//ticket_change_status 改签状态0未改签1改签中2改签完成
@property(nonatomic,copy) NSString *ticket_change_status;



@property(nonatomic,copy) NSString *phone;
@property(nonatomic,copy) NSString *sex;
@property(nonatomic,copy) NSString *isUserSelf;
@property(nonatomic,copy) NSString *checkstatus;
@property(nonatomic,copy) NSString *address;
@property(nonatomic,copy) NSString *birthday;
@property(nonatomic,copy) NSString *personType;///0成人  1儿童  2学生
@property(nonatomic,copy) NSString *tel;
@property(nonatomic,copy) NSString *identyType;
@property(nonatomic,copy) NSString *country;
@property(nonatomic,copy) NSString *email;
@property(nonatomic,copy) NSString *identy;

//passgens相关
@property(nonatomic,copy) NSString *passengersid;
@property(nonatomic,copy) NSString *insurance;
@property(nonatomic,copy) NSString *insurance_num;
@property(nonatomic,copy) NSString *passengersename;
@property(nonatomic,copy) NSString *passportseno;
@property(nonatomic,copy) NSString *passporttypeseid;
@property(nonatomic,copy) NSString *passporttypeseidname;
@property(nonatomic,copy) NSString *piaotype;
@property(nonatomic,copy) NSString *piaotypename;
@property(nonatomic,copy) NSString *price;
@property(nonatomic,copy) NSString *reason;
@property(nonatomic,copy) NSString *returnfailmsg;
@property(nonatomic,copy) NSString *returnmoney;
@property(nonatomic,copy) NSString *status;
@property(nonatomic,copy) NSString *ticket_no;
@property(nonatomic,copy) NSString *zwcode;
@property(nonatomic,copy) NSString *zwname;
/**
 *   套餐
 */
@property(nonatomic,copy)NSString *q_fee;





@property(nonatomic,copy) NSString *actual_price;
@property(nonatomic,copy) NSString *cxin;
@property(nonatomic,copy) NSString *max_price;
@property(nonatomic,copy) NSString *purch_fee;



@end

@interface SeatType : DataModel
@property(nonatomic,retain) NSString *name;
@property(nonatomic,assign) BOOL isSelect;

@property(nonatomic,retain) NSString *type_name;
@end

@interface OrderData : DataModel

//@property(nonatomic,copy) NSString *refund_online;
@property(nonatomic,copy) NSString *code;
@property(nonatomic,copy) NSString *checi;
@property(nonatomic,copy) NSString *arrive_time;
@property(nonatomic,copy) NSString *from_station_code;
@property(nonatomic,copy) NSString *from_station_name;
@property(nonatomic,copy) NSString *msg;//
@property(nonatomic,copy) NSString *orderid;
@property(nonatomic,copy) NSString *ordernumber;
@property(nonatomic,copy) NSArray <Customer *>*passengers;
@property(nonatomic,copy) NSString *refund_online;
@property(nonatomic,copy) NSString *reqtime;
@property(nonatomic,copy) NSString *runtime;
@property(nonatomic,copy) NSString *seattime;
@property(nonatomic,copy) NSString *start_time;
@property(nonatomic,copy) NSString *status;
@property(nonatomic,copy) NSString *identy;
@property(nonatomic,copy) NSString *to_station_code;
@property(nonatomic,copy) NSString *to_station_name;
@property(nonatomic,copy) NSString *train_date;
@property(nonatomic,copy) NSString *transactionid;

@property(nonatomic,copy) NSString *print_ticket_time;

@property(nonatomic,copy) NSString *take_county;
@property(nonatomic,copy) NSString *take_province;
@property(nonatomic,copy) NSString *mailno;

@property(nonatomic,copy) NSString *sendtype;
@property(nonatomic,copy) NSString *prompt_message;

@property(nonatomic,copy) NSString *take_city;

@property(nonatomic,copy) NSString *pack_time;

@property(nonatomic,copy) NSString *express_fee;

@property(nonatomic,copy) NSString *take_uname;
@property(nonatomic,copy) NSString *take_phone;
@property(nonatomic,copy) NSString *take_address;

@property(nonatomic,copy) NSString *shipping_time;
@property(nonatomic,copy) NSString *order_time;
@property(nonatomic,copy) NSString *max_price;



///12306抢票信息
@property(nonatomic,copy) NSString *start_date;
@property(nonatomic,copy) NSString *train_codes;
@property(nonatomic,copy) NSString *seat_type;

//人工抢票
@property(nonatomic,retain) NSArray *zwcodearr;
@property(nonatomic,assign)NSInteger  type;
/**
 *   状态是6或者7的时候对应的时间和车次
 */
@property(nonatomic,copy) NSString *sure_date;
@property(nonatomic,copy) NSString *sure_checi;
/**
 *   12306订票
 */
/**
 *   是否改签 0不是 1是改签票
 */
@property(nonatomic,copy) NSString *is_ticket_change;
/**
 *   新票信息(改签成功有内容)
 */
@property(nonatomic,copy) NSString *newtickets;
@end


