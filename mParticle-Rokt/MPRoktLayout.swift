//
//  MPRoktLayout.swift
//  mParticle-Rokt
//
//  Copyright 2025 Rokt Pte Ltd
//
//  Licensed under the Rokt Software Development Kit (SDK) Terms of Use
//  Version 2.0 (the "License");
//
//  You may not use this file except in compliance with the License.
//
//  You may obtain a copy of the License at https://rokt.com/sdk-license-2-0/

import SwiftUI
import Rokt_Widget
import mParticle_Apple_SDK

@available(iOS 15, *)
public struct MPRoktLayout: View {
    private var roktLayout: RoktLayout

    public init(
        sdkTriggered: Binding<Bool>,
        viewName: String? = nil,
        locationName: String = "",
        attributes: [String: String],
        config: RoktConfig? = nil,
        onLoad: (() -> Void)? = nil,
        onUnLoad: (() -> Void)? = nil,
        onShouldShowLoadingIndicator: (() -> Void)? = nil,
        onShouldHideLoadingIndicator: (() -> Void)? = nil
    ) {
        MPKitRokt.prepareAttributes(attributes, filteredUser: Optional<FilteredMParticleUser>.none, performMapping: true)

        self.roktLayout = RoktLayout.init(
            sdkTriggered: sdkTriggered,
            viewName: viewName,
            locationName: locationName,
            attributes: attributes,
            config: config,
            onLoad: onLoad,
            onUnLoad: onUnLoad,
            onShouldShowLoadingIndicator: onShouldShowLoadingIndicator,
            onShouldHideLoadingIndicator: onShouldHideLoadingIndicator
        )
    }

    public init(
        sdkTriggered: Binding<Bool>,
        viewName: String? = nil,
        locationName: String = "",
        attributes: [String: String],
        config: RoktConfig? = nil,
        onEvent: ((RoktEvent) -> Void)? = nil
    ) {
        self.roktLayout = RoktLayout.init(
            sdkTriggered: sdkTriggered,
            viewName: viewName,
            locationName: locationName,
            attributes: attributes,
            config: config,
            onEvent: onEvent
        )
    }

    public var body: some View {
        return self.roktLayout.body
    }
}
