// Generated by gencpp from file idxpendant/SwitchSrvRequest.msg
// DO NOT EDIT!


#ifndef IDXPENDANT_MESSAGE_SWITCHSRVREQUEST_H
#define IDXPENDANT_MESSAGE_SWITCHSRVREQUEST_H


#include <string>
#include <vector>
#include <map>

#include <ros/types.h>
#include <ros/serialization.h>
#include <ros/builtin_message_traits.h>
#include <ros/message_operations.h>


namespace idxpendant
{
template <class ContainerAllocator>
struct SwitchSrvRequest_
{
  typedef SwitchSrvRequest_<ContainerAllocator> Type;

  SwitchSrvRequest_()
    : switch_ref()  {
    }
  SwitchSrvRequest_(const ContainerAllocator& _alloc)
    : switch_ref(_alloc)  {
  (void)_alloc;
    }



   typedef std::basic_string<char, std::char_traits<char>, typename ContainerAllocator::template rebind<char>::other >  _switch_ref_type;
  _switch_ref_type switch_ref;




  typedef boost::shared_ptr< ::idxpendant::SwitchSrvRequest_<ContainerAllocator> > Ptr;
  typedef boost::shared_ptr< ::idxpendant::SwitchSrvRequest_<ContainerAllocator> const> ConstPtr;

}; // struct SwitchSrvRequest_

typedef ::idxpendant::SwitchSrvRequest_<std::allocator<void> > SwitchSrvRequest;

typedef boost::shared_ptr< ::idxpendant::SwitchSrvRequest > SwitchSrvRequestPtr;
typedef boost::shared_ptr< ::idxpendant::SwitchSrvRequest const> SwitchSrvRequestConstPtr;

// constants requiring out of line definition



template<typename ContainerAllocator>
std::ostream& operator<<(std::ostream& s, const ::idxpendant::SwitchSrvRequest_<ContainerAllocator> & v)
{
ros::message_operations::Printer< ::idxpendant::SwitchSrvRequest_<ContainerAllocator> >::stream(s, "", v);
return s;
}

} // namespace idxpendant

namespace ros
{
namespace message_traits
{



// BOOLTRAITS {'IsFixedSize': False, 'IsMessage': True, 'HasHeader': False}
// {'idxpendant': ['/home/eric/ros_idx6dof/src/idxpendant/msg'], 'std_msgs': ['/opt/ros/kinetic/share/std_msgs/cmake/../msg']}

// !!!!!!!!!!! ['__class__', '__delattr__', '__dict__', '__doc__', '__eq__', '__format__', '__getattribute__', '__hash__', '__init__', '__module__', '__ne__', '__new__', '__reduce__', '__reduce_ex__', '__repr__', '__setattr__', '__sizeof__', '__str__', '__subclasshook__', '__weakref__', '_parsed_fields', 'constants', 'fields', 'full_name', 'has_header', 'header_present', 'names', 'package', 'parsed_fields', 'short_name', 'text', 'types']




template <class ContainerAllocator>
struct IsFixedSize< ::idxpendant::SwitchSrvRequest_<ContainerAllocator> >
  : FalseType
  { };

template <class ContainerAllocator>
struct IsFixedSize< ::idxpendant::SwitchSrvRequest_<ContainerAllocator> const>
  : FalseType
  { };

template <class ContainerAllocator>
struct IsMessage< ::idxpendant::SwitchSrvRequest_<ContainerAllocator> >
  : TrueType
  { };

template <class ContainerAllocator>
struct IsMessage< ::idxpendant::SwitchSrvRequest_<ContainerAllocator> const>
  : TrueType
  { };

template <class ContainerAllocator>
struct HasHeader< ::idxpendant::SwitchSrvRequest_<ContainerAllocator> >
  : FalseType
  { };

template <class ContainerAllocator>
struct HasHeader< ::idxpendant::SwitchSrvRequest_<ContainerAllocator> const>
  : FalseType
  { };


template<class ContainerAllocator>
struct MD5Sum< ::idxpendant::SwitchSrvRequest_<ContainerAllocator> >
{
  static const char* value()
  {
    return "4cad5331d44c41d03096e603e96fba45";
  }

  static const char* value(const ::idxpendant::SwitchSrvRequest_<ContainerAllocator>&) { return value(); }
  static const uint64_t static_value1 = 0x4cad5331d44c41d0ULL;
  static const uint64_t static_value2 = 0x3096e603e96fba45ULL;
};

template<class ContainerAllocator>
struct DataType< ::idxpendant::SwitchSrvRequest_<ContainerAllocator> >
{
  static const char* value()
  {
    return "idxpendant/SwitchSrvRequest";
  }

  static const char* value(const ::idxpendant::SwitchSrvRequest_<ContainerAllocator>&) { return value(); }
};

template<class ContainerAllocator>
struct Definition< ::idxpendant::SwitchSrvRequest_<ContainerAllocator> >
{
  static const char* value()
  {
    return "string switch_ref\n\
";
  }

  static const char* value(const ::idxpendant::SwitchSrvRequest_<ContainerAllocator>&) { return value(); }
};

} // namespace message_traits
} // namespace ros

namespace ros
{
namespace serialization
{

  template<class ContainerAllocator> struct Serializer< ::idxpendant::SwitchSrvRequest_<ContainerAllocator> >
  {
    template<typename Stream, typename T> inline static void allInOne(Stream& stream, T m)
    {
      stream.next(m.switch_ref);
    }

    ROS_DECLARE_ALLINONE_SERIALIZER;
  }; // struct SwitchSrvRequest_

} // namespace serialization
} // namespace ros

namespace ros
{
namespace message_operations
{

template<class ContainerAllocator>
struct Printer< ::idxpendant::SwitchSrvRequest_<ContainerAllocator> >
{
  template<typename Stream> static void stream(Stream& s, const std::string& indent, const ::idxpendant::SwitchSrvRequest_<ContainerAllocator>& v)
  {
    s << indent << "switch_ref: ";
    Printer<std::basic_string<char, std::char_traits<char>, typename ContainerAllocator::template rebind<char>::other > >::stream(s, indent + "  ", v.switch_ref);
  }
};

} // namespace message_operations
} // namespace ros

#endif // IDXPENDANT_MESSAGE_SWITCHSRVREQUEST_H
