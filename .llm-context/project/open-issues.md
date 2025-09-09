# Open Issues - Flutter Boilerplate Project

## Overview
This document tracks open issues and improvements identified for the Flutter Boilerplate project, their implementation status, and priorities to enhance overall project quality and development experience.

## Current Active Issues

### High Priority Issues
| Issue ID | Date Reported | Issue Summary | Status | Priority | Assigned To | Target Resolution |
|----------|---------------|---------------|--------|----------|-------------|-------------------|
| FLT-001 | 2025-09-09 | BaseViewModel error handling needs improvement | Active | P1 | Mobile Team | 2025-09-16 |
| FLT-002 | 2025-09-09 | DI container memory management optimization needed | Active | P1 | Mobile Team | 2025-09-18 |
| FLT-003 | 2025-09-09 | ValueNotifier disposal in ViewModels | Active | P1 | Mobile Team | 2025-09-20 |
| FLT-004 | 2025-09-09 | Navigation argument type safety improvements | Active | P1 | Mobile Team | 2025-09-16 |

### Medium Priority Issues
| Issue ID | Date Reported | Issue Summary | Status | Priority | Assigned To | Target Resolution |
|----------|---------------|---------------|--------|----------|-------------|-------------------|
| FLT-005 | 2025-09-09 | Golden test setup and maintenance | Investigation | P2 | Mobile Team | 2025-09-25 |
| FLT-006 | 2025-09-09 | Flavor-specific configuration management | Backlog | P2 | Mobile Team | 2025-09-30 |
| FLT-007 | 2025-09-09 | SharedPreferences migration to secure storage | Investigation | P2 | Mobile Team | 2025-09-25 |

## Detailed Issue Descriptions

### DRV-001: Driver Receiving Ride Requests While Engagedi
**Category**: Trip Management  
**Impact**: Driver confusion, potential service disruption  
**Description**: In our system, the expected workflow is that when a customer searches for a ride, available drivers receive a ride request notification. Once a driver accepts the request, the system updates the driver's status to engaged (in-progress trip), and the assigned customer is notified that the driver is en route for pickup. During this engaged state, the driver should not be eligible to receive any new ride requests until the current ride is completed and the trip status is updated to finished. However, in the current implementation, there is a system flaw where drivers are still receiving new ride request notifications even while they are actively on a trip with a customer.

**Root Cause Analysis**:
- Driver status not properly updated in real-time
- Race condition in trip status management
- Incomplete state synchronization between services
- Missing validation in ride request distribution logic

**Proposed Solution**:
- Implement proper driver status management
- Add validation checks before sending ride requests
- Improve real-time status synchronization
- Add trip state validation mechanisms

### DRV-002: Incorrect Estimated Distance Calculation
**Category**: Navigation & Fare Calculation  
**Impact**: Customer dissatisfaction, fare disputes  
**Description**: In our system, the fare estimation process depends on the calculated distance between the pickup and drop-off points, typically retrieved from Google Maps API based on the shortest available route. The expected behavior is that the app will match Google Maps' calculated distance for the same origin and destination. However, for certain pickup and drop-off combinations, there is a significant mismatch. For example, Google Maps returns 17 km for the shortest available route, but our app calculates only 13 km. As a result, the fare shown to the customer before booking is underestimated. Once the trip is completed and the actual GPS-tracked distance (closer to 17 km) is recorded, the fare is recalculated to a higher amount, leading to customer dissatisfaction and possible fare disputes.

**Root Cause Analysis**:
- Incorrect Google Maps API parameter usage
- Route calculation algorithm discrepancies
- Missing traffic and road condition considerations
- GPS tracking vs. estimated distance mismatch

**Proposed Solution**:
- Review and fix Google Maps API integration
- Implement consistent distance calculation methods
- Add validation against multiple route sources
- Improve GPS tracking accuracy

### DRV-003: Wrong Route Generation for CNG Trips
**Category**: Navigation & Route Planning  
**Impact**: Fare estimation errors, customer disputes  
**Description**: When generating navigation routes for CNG trips, the app should only return routes compliant with vehicle type restrictions. In the case of CNGs, they are not permitted to use the elevated expressway. The expected behavior is that the routing algorithm should exclude such restricted roads from the suggested path. However, in the current implementation, CNG trip routes often include the elevated expressway in the generated path. This leads to shorter estimated distances and lower fare estimates being shown to customers during booking. Once the driver avoids the expressway in reality and takes a longer alternative route, the actual distance increases, resulting in higher final fares and potential disputes with customers.

**Root Cause Analysis**:
- Missing vehicle type restrictions in routing logic
- Inadequate road restriction database
- Route generation not considering vehicle limitations
- Lack of validation for vehicle-specific routes

**Proposed Solution**:
- Implement vehicle type-aware routing
- Add comprehensive road restriction database
- Validate routes against vehicle capabilities
- Update routing algorithms for compliance

### DRV-004: Ping Issue - Drivers Not Receiving Requests
**Category**: Real-time Communication  
**Impact**: Driver income loss, service availability issues  
**Description**: In our current architecture, the driver app sends a ping request to the backend server at a fixed 10-second interval. This periodic ping is used by the backend to update the driver's availability status in real time and ensure they are included in the ride-matching pool. However, in certain cases, the driver's status continues to display as "online" in the system, but the driver does not receive any incoming ride requests.

**Root Cause Analysis**:
- Ping mechanism reliability issues
- Server-side status update failures
- Network connectivity problems
- Ride matching algorithm excluding active drivers

**Proposed Solution**:
- Improve ping reliability and error handling
- Add redundant status verification mechanisms
- Implement better network failure recovery
- Debug ride matching algorithm

### DRV-005: Unable to Change bKash Account
**Category**: Payment Management  
**Impact**: Driver inconvenience, operational overhead  
**Description**: Drivers are currently unable to add or remove their bKash account directly from the in-app "Payment" section. The expected behavior is that drivers should have self-service access to manage their linked bKash account without external support. However, due to the current limitation, they must contact Customer Care to make changes, causing delays and additional operational overhead.

**Root Cause Analysis**:
- Missing self-service payment management features
- Incomplete bKash integration implementation
- Security restrictions preventing account changes
- UI/UX limitations in payment section

**Proposed Solution**:
- Implement self-service bKash account management
- Add proper security validation for account changes
- Update UI to include payment management options
- Integrate with bKash account modification APIs

### DRV-006: Fare Discrepancy in Trip Calculations
**Category**: Fare Calculation  
**Impact**: Customer trust issues, financial disputes  
**Description**: In our fare estimation system, the calculated fare should accurately reflect the actual trip distance. For a recent case, the estimated fare for a 10.92 km trip was BDT 316. However, due to a technical issue in distance calculation or fare application logic, the fare unexpectedly increased to BDT 616 despite the actual GPS-recorded distance being only 5.59 km. The customer ultimately paid BDT 600. This inconsistency creates mistrust and increases the likelihood of disputes.

**Root Cause Analysis**:
- Fare calculation algorithm errors
- Distance measurement inconsistencies
- GPS tracking accuracy issues
- Fare logic implementation bugs

**Proposed Solution**:
- Audit and fix fare calculation algorithms
- Implement consistent distance measurement
- Improve GPS tracking accuracy
- Add fare validation and verification systems

### DRV-007: Battery Drain Issue
**Category**: Performance  
**Impact**: Driver device performance, operational efficiency  
**Description**: The app exhibits unusually high battery consumption during normal usage, leading to faster-than-expected power depletion on driver devices. This is likely due to continuous background location tracking, inefficient API polling intervals, or unoptimized background processes, which need investigation and optimization to improve device performance and user satisfaction.

**Root Cause Analysis**:
- Continuous background location tracking
- Inefficient API polling intervals (10-second pings)
- Unoptimized background processes
- Excessive network requests

**Proposed Solution**:
- Optimize location tracking frequency
- Implement intelligent polling based on driver status
- Review and optimize background processes
- Implement battery usage monitoring

## Issue Categories and Patterns

### Technical Issues Distribution
- **Navigation & Fare Calculation**: 43% (Distance calculation, route generation, fare discrepancy)
- **Real-time Communication**: 29% (Ping issues, status synchronization)
- **Performance Issues**: 14% (Battery drain)
- **Payment Management**: 14% (bKash account management)

### Common Issue Patterns
1. **Trip Management**: Issues with driver status and ride request distribution
2. **Route & Distance Calculation**: Problems with Google Maps API integration and vehicle-specific routing
3. **Real-time Communication**: Ping mechanism and status synchronization failures
4. **Payment Integration**: Self-service payment management limitations

## Resolution Tracking

### Resolution Time Metrics
- **Average Resolution Time**: 7-14 days
- **High Priority (P1)**: 5-7 days average
- **Medium Priority (P2)**: 10-14 days average
- **Low Priority (P3)**: 21+ days average

## Driver Impact Assessment

### Driver Experience Impact
- **Trip Management Issues**: Confusion from receiving requests while engaged, affects productivity
- **Distance/Fare Calculation**: Leads to customer disputes and driver reputation damage
- **Route Generation**: CNG drivers face compliance issues and fare disputes
- **Ping Issues**: Loss of income due to missed ride requests
- **Payment Management**: Operational delays requiring customer service contact
- **Battery Drain**: Affects device performance and operational efficiency

### Business Impact
- **Revenue**: Fare calculation errors affect pricing accuracy and customer trust
- **Driver Retention**: Technical issues may cause drivers to switch platforms
- **Support Load**: Payment and technical issues increase customer service tickets
- **Operational Efficiency**: Manual processes for payment changes reduce efficiency
- **Compliance Risk**: CNG route violations may lead to regulatory issues

## Preventive Measures

### Code Quality Improvements
- Enhanced driver status management and trip state validation
- Improved Google Maps API integration and route calculation
- Better real-time communication and ping mechanisms
- Comprehensive testing for fare calculation and payment features

### Monitoring and Alerting
- Driver status and trip state monitoring
- Fare calculation accuracy tracking
- Route generation validation alerts
- Payment system transaction monitoring

## Action Items

### Immediate Actions (Next 7 Days)
- [ ] Implement driver status validation in ride request distribution
- [ ] Audit Google Maps API parameters and distance calculation
- [ ] Fix CNG route generation to exclude restricted roads
- [ ] Review fare calculation algorithms for accuracy

### Short-term Improvements (Next 30 Days)
- [ ] Optimize ping mechanism reliability and error handling
- [ ] Implement self-service bKash account management
- [ ] Add vehicle type-aware routing logic
- [ ] Improve battery optimization for location tracking

### Long-term Enhancements (Next 90 Days)
- [ ] Develop comprehensive trip state management system
- [ ] Build advanced fare validation and verification framework
- [ ] Create intelligent route optimization for all vehicle types
- [ ] Implement driver analytics and performance dashboard

## Communication Templates

### Driver Response Templates
```
Trip Management Issue Response:
"We've identified the issue with ride requests during active trips and are implementing a fix. The update will be deployed by [DATE] to ensure you only receive requests when available."

Distance Calculation Response:
"We're aware of the distance calculation discrepancies and are reviewing our Google Maps integration. A fix is being tested and will be released by [DATE] to ensure accurate fare estimates."

Route Generation Response:
"Thank you for reporting the CNG route issue. We're updating our routing algorithm to comply with vehicle restrictions. The fix will be available in the next app update by [DATE]."

Payment Management Response:
"We're working on adding self-service bKash account management to the app. This feature will be available in version X.X.X, expected by [DATE]. Until then, please contact Customer Care for account changes."
```

## Knowledge Base

### Common Solutions
1. **Trip Management Issues**: Check driver status, restart app, verify trip completion
2. **Route Problems**: Update app to latest version, check location permissions, verify vehicle type settings
3. **Payment Issues**: Contact Customer Care for bKash account changes, verify payment method settings
4. **Battery Issues**: Optimize location settings, close unnecessary apps, check background app refresh

### Technical Debt Items
- Driver status management system needs comprehensive overhaul
- Google Maps API integration requires optimization and validation
- Payment management system needs self-service capabilities
- Route calculation algorithms need vehicle type awareness

---

*Last Updated: 2025-09-08*  
*Next Review: 2025-09-15*  
*Document Owner: Product Team*
