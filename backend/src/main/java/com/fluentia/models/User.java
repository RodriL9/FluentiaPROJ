package com.fluentia.models;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.time.Instant;
import java.time.LocalDate;
import java.util.UUID;

@Entity
@Table(name = "users")
@Getter
@Setter
@NoArgsConstructor
public class User {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;
    private String fullName;
    private String email;
    private String username;
    private String passwordHash;
    private String oauthProvider;
    private String oauthId;
    private String nativeLanguage;
    private String learningLanguage;
    private String assignedLevel;
    private String role;
    private Boolean isVerified;
    private String accountStatus;
    private String emailVerificationToken;
    private Instant emailVerifiedAt;
    private String passwordResetToken;
    private Instant passwordResetExpires;
    private Boolean isPremium;
    private Instant premiumExpiresAt;
    private Integer xp;
    private Integer streakCount;
    private LocalDate lastActiveDate;
    private Instant lastLoginAt;
    private Integer loginCount;
    private String learningGoals;
    private String profilePictureUrl;
    private Boolean onboardingCompleted;
    private Boolean isActive;
    private Instant joinedAt;
    private Instant updatedAt;

}
