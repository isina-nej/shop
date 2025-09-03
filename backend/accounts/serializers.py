from rest_framework import serializers
from django.contrib.auth import get_user_model
from django.utils.translation import gettext_lazy as _
from .models import UserProfile, Address, UserActivity

User = get_user_model()


class UserSerializer(serializers.ModelSerializer):
    """User serializer"""
    profile = serializers.SerializerMethodField()
    is_online = serializers.SerializerMethodField()

    class Meta:
        model = User
        fields = [
            'id', 'email', 'first_name', 'last_name', 'phone_number',
            'is_active', 'is_staff', 'date_joined', 'last_login',
            'profile', 'is_online'
        ]
        read_only_fields = ['id', 'date_joined', 'last_login']

    def get_profile(self, obj):
        if hasattr(obj, 'profile'):
            return UserProfileSerializer(obj.profile).data
        return None

    def get_is_online(self, obj):
        return obj.is_online()


class UserProfileSerializer(serializers.ModelSerializer):
    """User profile serializer"""
    user = UserSerializer(read_only=True)

    class Meta:
        model = UserProfile
        fields = [
            'id', 'user', 'avatar', 'bio', 'birth_date', 'gender',
            'phone_number', 'address', 'city', 'country', 'postal_code',
            'preferred_language', 'newsletter_subscription',
            'marketing_emails', 'created_at', 'updated_at'
        ]
        read_only_fields = ['id', 'created_at', 'updated_at']


class AddressSerializer(serializers.ModelSerializer):
    """Address serializer"""

    class Meta:
        model = Address
        fields = [
            'id', 'user', 'title', 'first_name', 'last_name',
            'company', 'address_line_1', 'address_line_2',
            'city', 'state', 'postal_code', 'country',
            'phone_number', 'is_default', 'created_at', 'updated_at'
        ]
        read_only_fields = ['id', 'user', 'created_at', 'updated_at']


class UserActivitySerializer(serializers.ModelSerializer):
    """User activity serializer"""

    class Meta:
        model = UserActivity
        fields = [
            'id', 'user', 'activity_type', 'description',
            'ip_address', 'user_agent', 'timestamp'
        ]
        read_only_fields = ['id', 'user', 'timestamp']


class RegisterSerializer(serializers.ModelSerializer):
    """User registration serializer"""
    password = serializers.CharField(write_only=True, min_length=8)
    password_confirm = serializers.CharField(write_only=True)

    class Meta:
        model = User
        fields = [
            'email', 'first_name', 'last_name', 'phone_number',
            'password', 'password_confirm'
        ]

    def validate(self, attrs):
        if attrs['password'] != attrs['password_confirm']:
            raise serializers.ValidationError(
                {'password_confirm': _("Passwords don't match.")}
            )
        return attrs

    def create(self, validated_data):
        validated_data.pop('password_confirm')
        user = User.objects.create_user(**validated_data)
        return user


class LoginSerializer(serializers.Serializer):
    """Login serializer"""
    email = serializers.EmailField()
    password = serializers.CharField()


class ChangePasswordSerializer(serializers.Serializer):
    """Change password serializer"""
    old_password = serializers.CharField()
    new_password = serializers.CharField(min_length=8)
    new_password_confirm = serializers.CharField()

    def validate(self, attrs):
        if attrs['new_password'] != attrs['new_password_confirm']:
            raise serializers.ValidationError(
                {'new_password_confirm': _("Passwords don't match.")}
            )
        return attrs


class ForgotPasswordSerializer(serializers.Serializer):
    """Forgot password serializer"""
    email = serializers.EmailField()


class ResetPasswordSerializer(serializers.Serializer):
    """Reset password serializer"""
    token = serializers.CharField()
    new_password = serializers.CharField(min_length=8)
    new_password_confirm = serializers.CharField()

    def validate(self, attrs):
        if attrs['new_password'] != attrs['new_password_confirm']:
            raise serializers.ValidationError(
                {'new_password_confirm': _("Passwords don't match.")}
            )
        return attrs


class VerifyEmailSerializer(serializers.Serializer):
    """Email verification serializer"""
    token = serializers.CharField()


class ResendVerificationSerializer(serializers.Serializer):
    """Resend verification serializer"""
    email = serializers.EmailField()
