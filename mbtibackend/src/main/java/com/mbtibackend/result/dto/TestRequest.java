package com.mbtibackend.result.dto;

import com.mbtibackend.answer.dto.TestAnswer;
import lombok.*;

import java.util.List;

@Getter @Setter
@NoArgsConstructor
@AllArgsConstructor
@ToString
public class TestRequest {
    private String userName;
    private List<TestAnswer> answers;
}
