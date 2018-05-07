import Foundation
import CoreBluetooth

/// Bluetooth error which can be emitted by RxBluetoothKit created observables.
public enum BluetoothError: Error {
    /// Emitted when the object that is the source of Observable was destroyed and event was emitted nevertheless.
    /// To mitigate it dispose all of your subscriptions before deinitializing
    /// object that created Observables that subscriptions are made to.
    case destroyed
    // Emitted when `CentralManager.scanForPeripherals` called and there is already ongoing scan
    case scanInProgress
    // States
    case bluetoothUnsupported
    case bluetoothUnauthorized
    case bluetoothPoweredOff
    case bluetoothInUnknownState
    case bluetoothResetting
    // Peripheral
    case peripheralIsAlreadyObservingConnection(Peripheral)
    @available(*, deprecated: 5.0.2, renamed: "BluetoothError.peripheralIsAlreadyObservingConnection")
    case peripheralIsConnectingOrAlreadyConnected(Peripheral)
    case peripheralConnectionFailed(Peripheral, Error?)
    case peripheralDisconnected(Peripheral, Error?)
    case peripheralRSSIReadFailed(Peripheral, Error?)
    // Services
    case servicesDiscoveryFailed(Peripheral, Error?)
    case includedServicesDiscoveryFailed(Peripheral, Error?)
    // Characteristics
    case characteristicsDiscoveryFailed(Service, Error?)
    case characteristicWriteFailed(Characteristic, Error?)
    case characteristicReadFailed(Characteristic, Error?)
    case characteristicNotifyChangeFailed(Characteristic, Error?)
    case characteristicSetNotifyValueFailed(Characteristic, Error?)
    // Descriptors
    case descriptorsDiscoveryFailed(Characteristic, Error?)
    case descriptorWriteFailed(Descriptor, Error?)
    case descriptorReadFailed(Descriptor, Error?)
    //L2CAP
    case openingL2CAPChannelFailed(Peripheral, Error?)
}

extension BluetoothError: CustomStringConvertible {

    /// Human readable description of bluetooth error
    public var description: String {
        switch self {
        case .destroyed:
            return """
            The object that is the source of this Observable was destroyed.
            It's programmer's error, please check documentation of error for more details
            """
        case .scanInProgress:
            return """
            Tried to scan for peripheral when there is already ongoing scan.
            You can have only 1 ongoing scanning, please check documentation of CentralManager for more details
            """
        case .bluetoothUnsupported:
            return "Bluetooth is unsupported"
        case .bluetoothUnauthorized:
            return "Bluetooth is unauthorized"
        case .bluetoothPoweredOff:
            return "Bluetooth is powered off"
        case .bluetoothInUnknownState:
            return "Bluetooth is in unknown state"
        case .bluetoothResetting:
            return "Bluetooth is resetting"
        // Peripheral
        case .peripheralIsAlreadyObservingConnection, .peripheralIsConnectingOrAlreadyConnected:
            return """
            Peripheral connection is already being observed.
            You cannot try to establishConnection to peripheral when you have ongoing
            connection (previously establishConnection subscription was not disposed).
            """
        case let .peripheralConnectionFailed(_, err):
            return "Connection error has occured: \(err?.localizedDescription ?? "-")"
        case let .peripheralDisconnected(_, err):
            return "Connection error has occured: \(err?.localizedDescription ?? "-")"
        case let .peripheralRSSIReadFailed(_, err):
            return "RSSI read failed : \(err?.localizedDescription ?? "-")"
        // Services
        case let .servicesDiscoveryFailed(_, err):
            return "Services discovery error has occured: \(err?.localizedDescription ?? "-")"
        case let .includedServicesDiscoveryFailed(_, err):
            return "Included services discovery error has occured: \(err?.localizedDescription ?? "-")"
        // Characteristics
        case let .characteristicsDiscoveryFailed(_, err):
            return "Characteristics discovery error has occured: \(err?.localizedDescription ?? "-")"
        case let .characteristicWriteFailed(_, err):
            return "Characteristic write error has occured: \(err?.localizedDescription ?? "-")"
        case let .characteristicReadFailed(_, err):
            return "Characteristic read error has occured: \(err?.localizedDescription ?? "-")"
        case let .characteristicNotifyChangeFailed(_, err):
            return "Characteristic notify change error has occured: \(err?.localizedDescription ?? "-")"
        case let .characteristicSetNotifyValueFailed(_, err):
            return "Characteristic isNotyfing value change error has occured: \(err?.localizedDescription ?? "-")"
        // Descriptors
        case let .descriptorsDiscoveryFailed(_, err):
            return "Descriptor discovery error has occured: \(err?.localizedDescription ?? "-")"
        case let .descriptorWriteFailed(_, err):
            return "Descriptor write error has occured: \(err?.localizedDescription ?? "-")"
        case let .descriptorReadFailed(_, err):
            return "Descriptor read error has occured: \(err?.localizedDescription ?? "-")"
        case let .openingL2CAPChannelFailed(_, err):
            return "Opening L2CAP channel error has occured: \(err?.localizedDescription ?? "-")"
        }
    }
}

extension BluetoothError {
    init?(state: BluetoothState) {
        switch state {
        case .unsupported:
            self = .bluetoothUnsupported
        case .unauthorized:
            self = .bluetoothUnauthorized
        case .poweredOff:
            self = .bluetoothPoweredOff
        case .unknown:
            self = .bluetoothInUnknownState
        case .resetting:
            self = .bluetoothResetting
        default:
            return nil
        }
    }
}

extension BluetoothError: Equatable {}

// swiftlint:disable cyclomatic_complexity

public func == (lhs: BluetoothError, rhs: BluetoothError) -> Bool {
    switch (lhs, rhs) {
    case (.scanInProgress, .scanInProgress): return true
    // States
    case (.bluetoothUnsupported, .bluetoothUnsupported): return true
    case (.bluetoothUnauthorized, .bluetoothUnauthorized): return true
    case (.bluetoothPoweredOff, .bluetoothPoweredOff): return true
    case (.bluetoothInUnknownState, .bluetoothInUnknownState): return true
    case (.bluetoothResetting, .bluetoothResetting): return true
    // Services
    case let (.servicesDiscoveryFailed(l, _), .servicesDiscoveryFailed(r, _)): return l == r
    case let (.includedServicesDiscoveryFailed(l, _), .includedServicesDiscoveryFailed(r, _)): return l == r
    // Peripherals
    case let (.peripheralIsAlreadyObservingConnection(l), .peripheralIsAlreadyObservingConnection(r)): return l == r
    case let (.peripheralIsConnectingOrAlreadyConnected(l), .peripheralIsConnectingOrAlreadyConnected(r)): return l == r
    case let (.peripheralIsAlreadyObservingConnection(l), .peripheralIsConnectingOrAlreadyConnected(r)): return l == r
    case let (.peripheralIsConnectingOrAlreadyConnected(l), .peripheralIsAlreadyObservingConnection(r)): return l == r
    case let (.peripheralConnectionFailed(l, _), .peripheralConnectionFailed(r, _)): return l == r
    case let (.peripheralDisconnected(l, _), .peripheralDisconnected(r, _)): return l == r
    case let (.peripheralRSSIReadFailed(l, _), .peripheralRSSIReadFailed(r, _)): return l == r
    // Characteristics
    case let (.characteristicsDiscoveryFailed(l, _), .characteristicsDiscoveryFailed(r, _)): return l == r
    case let (.characteristicWriteFailed(l, _), .characteristicWriteFailed(r, _)): return l == r
    case let (.characteristicReadFailed(l, _), .characteristicReadFailed(r, _)): return l == r
    case let (.characteristicNotifyChangeFailed(l, _), .characteristicNotifyChangeFailed(r, _)): return l == r
    case let (.characteristicSetNotifyValueFailed(l, _), .characteristicSetNotifyValueFailed(r, _)): return l == r
    // Descriptors
    case let (.descriptorsDiscoveryFailed(l, _), .descriptorsDiscoveryFailed(r, _)): return l == r
    case let (.descriptorWriteFailed(l, _), .descriptorWriteFailed(r, _)): return l == r
    case let (.descriptorReadFailed(l, _), .descriptorReadFailed(r, _)): return l == r
    // L2CAP
    case let (.openingL2CAPChannelFailed(l, _), .openingL2CAPChannelFailed(r, _)): return l == r
    default: return false
    }
}

// swiftlint:enable cyclomatic_complexity
