// Generated by gencpp from file idxpendant/SwitchSrv.msg
// DO NOT EDIT!


#ifndef IDXPENDANT_MESSAGE_SWITCHSRV_H
#define IDXPENDANT_MESSAGE_SWITCHSRV_H

#include <ros/service_traits.h>


#include <idxpendant/SwitchSrvRequest.h>
#include <idxpendant/SwitchSrvResponse.h>


namespace idxpendant
{

struct SwitchSrv
{

typedef SwitchSrvRequest Request;
typedef SwitchSrvResponse Response;
Request request;
Response response;

typedef Request RequestType;
typedef Response ResponseType;

}; // struct SwitchSrv
} // namespace idxpendant


namespace ros
{
namespace service_traits
{


template<>
struct MD5Sum< ::idxpendant::SwitchSrv > {
  static const char* value()
  {
    return "ec07742aef364f2fbeeee9a3d0cc94bc";
  }

  static const char* value(const ::idxpendant::SwitchSrv&) { return value(); }
};

template<>
struct DataType< ::idxpendant::SwitchSrv > {
  static const char* value()
  {
    return "idxpendant/SwitchSrv";
  }

  static const char* value(const ::idxpendant::SwitchSrv&) { return value(); }
};


// service_traits::MD5Sum< ::idxpendant::SwitchSrvRequest> should match 
// service_traits::MD5Sum< ::idxpendant::SwitchSrv > 
template<>
struct MD5Sum< ::idxpendant::SwitchSrvRequest>
{
  static const char* value()
  {
    return MD5Sum< ::idxpendant::SwitchSrv >::value();
  }
  static const char* value(const ::idxpendant::SwitchSrvRequest&)
  {
    return value();
  }
};

// service_traits::DataType< ::idxpendant::SwitchSrvRequest> should match 
// service_traits::DataType< ::idxpendant::SwitchSrv > 
template<>
struct DataType< ::idxpendant::SwitchSrvRequest>
{
  static const char* value()
  {
    return DataType< ::idxpendant::SwitchSrv >::value();
  }
  static const char* value(const ::idxpendant::SwitchSrvRequest&)
  {
    return value();
  }
};

// service_traits::MD5Sum< ::idxpendant::SwitchSrvResponse> should match 
// service_traits::MD5Sum< ::idxpendant::SwitchSrv > 
template<>
struct MD5Sum< ::idxpendant::SwitchSrvResponse>
{
  static const char* value()
  {
    return MD5Sum< ::idxpendant::SwitchSrv >::value();
  }
  static const char* value(const ::idxpendant::SwitchSrvResponse&)
  {
    return value();
  }
};

// service_traits::DataType< ::idxpendant::SwitchSrvResponse> should match 
// service_traits::DataType< ::idxpendant::SwitchSrv > 
template<>
struct DataType< ::idxpendant::SwitchSrvResponse>
{
  static const char* value()
  {
    return DataType< ::idxpendant::SwitchSrv >::value();
  }
  static const char* value(const ::idxpendant::SwitchSrvResponse&)
  {
    return value();
  }
};

} // namespace service_traits
} // namespace ros

#endif // IDXPENDANT_MESSAGE_SWITCHSRV_H