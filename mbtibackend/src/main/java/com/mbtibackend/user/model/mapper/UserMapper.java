package com.mbtibackend.user.model.mapper;

import com.mbtibackend.user.model.dto.User;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface UserMapper {
    List<User> selectAll();
    User selectById(int id);
    User selectByUserName(String userName);
//    void insert(User user);
    void updateLastLogin(int id);
    void delete(int id);
    void insertUser(User user);
}
