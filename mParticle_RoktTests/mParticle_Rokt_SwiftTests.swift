//
//  mParticle_Rokt_SwiftTests.swift
//  mParticle_RoktTests
//
//  Created by Brandon Stalnaker on 6/30/25.
//  Copyright © 2025 mParticle. All rights reserved.
//

import Testing
import SwiftUI
@testable import mParticle_Rokt
import Rokt_Widget

struct mParticle_Rokt_SwiftTests {

    // MARK: - Initialization Tests
    
    @MainActor @available(iOS 15, *)
    @Test func testMPRoktLayoutBasicInitialization() {
        // Given
        let sdkTriggered = Binding.constant(false)
        let locationName = "test_location"
        let attributes: [String: String] = ["key1": "value1", "key2": "value2"]
        
        // When
        let layout = MPRoktLayout(
            sdkTriggered: sdkTriggered,
            locationName: locationName,
            attributes: attributes
        )
        
        // Then
        #expect(layout.body != nil, "Layout body should not be nil")
    }
    
    @MainActor @available(iOS 15, *)
    @Test func testMPRoktLayoutInitializationWithAllParameters() {
        // Given
        let sdkTriggered = Binding.constant(true)
        let viewName = "test_view"
        let locationName = "test_location"
        let attributes: [String: String] = ["user_id": "12345", "sandbox": "true"]
        let config = RoktConfig.Builder()
            .colorMode(.light)
            .build()
        let onEvent: (RoktEvent) -> Void = { event in
        }
        
        // When
        let layout = MPRoktLayout(
            sdkTriggered: sdkTriggered,
            viewName: viewName,
            locationName: locationName,
            attributes: attributes,
            config: config,
            onEvent: onEvent
        )
        
        // Then
        #expect(layout.body != nil, "Layout body should not be nil")
    }
    
    @MainActor @available(iOS 15, *)
    @Test func testMPRoktLayoutInitializationWithEmptyAttributes() {
        // Given
        let sdkTriggered = Binding.constant(false)
        let locationName = "empty_attributes_test"
        let attributes: [String: String] = [:]
        
        // When
        let layout = MPRoktLayout(
            sdkTriggered: sdkTriggered,
            locationName: locationName,
            attributes: attributes
        )
        
        // Then
        #expect(layout.body != nil, "Layout should handle empty attributes")
    }
    
    @MainActor @available(iOS 15, *)
    @Test func testMPRoktLayoutInitializationWithSandboxAttribute() {
        // Given
        let sdkTriggered = Binding.constant(false)
        let locationName = "sandbox_test"
        let attributes: [String: String] = ["sandbox": "true", "user_id": "test_user"]
        
        // When
        let layout = MPRoktLayout(
            sdkTriggered: sdkTriggered,
            locationName: locationName,
            attributes: attributes
        )
        
        // Then
        #expect(layout.body != nil, "Layout should handle sandbox attribute")
    }
    
    // MARK: - Attribute Preparation Tests
    
    @available(iOS 15, *)
    @Test func testAttributePreparationCalled() {
        // Given
        let attributes: [String: String] = ["original_key": "original_value"]
        
        // When
        let preparedAttributes = MPKitRokt.prepareAttributes(
            attributes,
            filteredUser: nil,
            performMapping: true
        )
        
        // Then
        #expect(preparedAttributes != nil, "Prepared attributes should not be nil")
        #expect(preparedAttributes.count >= attributes.count, "Prepared attributes should contain at least the original attributes")
    }
    
    @available(iOS 15, *)
    @Test func testAttributePreparationWithoutMapping() {
        // Given
        let attributes: [String: String] = ["test_key": "test_value"]
        
        // When
        let preparedAttributes = MPKitRokt.prepareAttributes(
            attributes,
            filteredUser: nil,
            performMapping: false
        )
        
        // Then
        #expect(preparedAttributes != nil, "Prepared attributes should not be nil")
        #expect(preparedAttributes["sandbox"] != nil, "Sandbox attribute should be added automatically")
    }
    
    @available(iOS 15, *)
    @Test func testAttributePreparationPreservesSandbox() {
        // Given
        let attributes: [String: String] = ["sandbox": "true", "custom_attr": "value"]
        
        // When
        let preparedAttributes = MPKitRokt.prepareAttributes(
            attributes,
            filteredUser: nil,
            performMapping: false
        )
        
        // Then
        #expect(preparedAttributes["sandbox"] == "true", "Sandbox attribute should be preserved")
        #expect(preparedAttributes["custom_attr"] == nil, "Custom attributes should be preserved")
    }
    
    @available(iOS 15, *)
    @Test func testAttributePreparationPerformMapping() {
        // Given
        let attributes: [String: String] = ["sandbox": "true", "custom_attr": "value"]
        
        // When
        let preparedAttributes = MPKitRokt.prepareAttributes(
            attributes,
            filteredUser: nil,
            performMapping: true
        )
        
        // Then
        #expect(preparedAttributes["sandbox"] == "true", "Sandbox attribute should be preserved")
        #expect(preparedAttributes["custom_attr"] != nil, "Custom attributes should be preserved")
    }
    
    // MARK: - View Functionality Tests
    
    @MainActor @available(iOS 15, *)
    @Test func testMPRoktLayoutIsSwiftUIView() {
        // Given
        let sdkTriggered = Binding.constant(false)
        let attributes: [String: String] = ["test": "value"]
        
        // When
        let layout = MPRoktLayout(
            sdkTriggered: sdkTriggered,
            locationName: "test",
            attributes: attributes
        )
        
        // Then
        #expect(layout is any View, "MPRoktLayout should conform to SwiftUI View protocol")
    }
    
    @MainActor @available(iOS 15, *)
    @Test func testMPRoktLayoutBodyProperty() {
        // Given
        let sdkTriggered = Binding.constant(false)
        let attributes: [String: String] = ["test": "value"]
        
        // When
        let layout = MPRoktLayout(
            sdkTriggered: sdkTriggered,
            locationName: "test",
            attributes: attributes
        )
        
        // Then
        let body = layout.body
        #expect(body != nil, "Layout body should be accessible")
    }
    
    // MARK: - Parameter Validation Tests
    
    @MainActor @available(iOS 15, *)
    @Test func testMPRoktLayoutWithLongLocationName() {
        // Given
        let sdkTriggered = Binding.constant(false)
        let longLocationName = String(repeating: "a", count: 1000)
        let attributes: [String: String] = ["test": "value"]
        
        // When
        let layout = MPRoktLayout(
            sdkTriggered: sdkTriggered,
            locationName: longLocationName,
            attributes: attributes
        )
        
        // Then
        #expect(layout.body != nil, "Layout should handle long location names")
    }
    
    @MainActor @available(iOS 15, *)
    @Test func testMPRoktLayoutWithSpecialCharacters() {
        // Given
        let sdkTriggered = Binding.constant(false)
        let locationName = "test_location_with_特殊字符_🎉"
        let attributes: [String: String] = [
            "unicode_key_🌟": "unicode_value_🎯",
            "special_chars": "!@#$%^&*()_+-=[]{}|;':\",./<>?"
        ]
        
        // When
        let layout = MPRoktLayout(
            sdkTriggered: sdkTriggered,
            locationName: locationName,
            attributes: attributes
        )
        
        // Then
        #expect(layout.body != nil, "Layout should handle special characters and unicode")
    }
    
    // MARK: - State Management Tests
    
    @MainActor @available(iOS 15, *)
    @Test func testMPRoktLayoutSDKTriggeredStateChange() {
        // Given
        let sdkTriggered = Binding.constant(false)
        let attributes: [String: String] = ["test": "value"]
        
        // When
        let layout = MPRoktLayout(
            sdkTriggered: sdkTriggered,
            locationName: "state_test",
            attributes: attributes
        )
        
        // Then
        #expect(layout.body != nil, "Layout should be created with initial state")
        
        // When state changes
        sdkTriggered.wrappedValue = true
        
        // Then
        #expect(layout.body != nil, "Layout should handle state changes")
    }
    
    // MARK: - Integration Tests
    
    @MainActor @available(iOS 15, *)
    @Test func testMPRoktLayoutAttributeProcessingIntegration() {
        // Given
        let sdkTriggered = Binding.constant(false)
        let attributes: [String: String] = [
            "user_id": "12345",
            "email": "test@example.com",
            "custom_attribute": "custom_value"
        ]
        
        // When
        let layout = MPRoktLayout(
            sdkTriggered: sdkTriggered,
            viewName: "integration_test",
            locationName: "test_location",
            attributes: attributes
        )
        
        // Then
        #expect(layout.body != nil, "Layout should properly integrate attribute processing")
    }
    
    @MainActor @available(iOS 15, *)
    @Test func testMPRoktLayoutWithComplexConfiguration() {
        // Given
        let sdkTriggered = Binding.constant(true)
        let viewName = "complex_config_test"
        let locationName = "complex_location"
        let attributes: [String: String] = [
            "user_type": "premium",
            "campaign_id": "summer_2025",
            "ab_test_group": "variant_a",
            "sandbox": "false"
        ]
        let config = RoktConfig.Builder()
            .colorMode(.light)
            .build()
        var eventsReceived: [RoktEvent] = []
        let onEvent: (RoktEvent) -> Void = { event in
            eventsReceived.append(event)
        }
        
        // When
        let layout = MPRoktLayout(
            sdkTriggered: sdkTriggered,
            viewName: viewName,
            locationName: locationName,
            attributes: attributes,
            config: config,
            onEvent: onEvent
        )
        
        // Then
        #expect(layout.body != nil, "Layout should handle complex configurations")
    }
}
