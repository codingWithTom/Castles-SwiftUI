//
//  ComplicationController.swift
//  CastlesWatch Extension
//
//  Created by Tomas Trujillo on 2021-03-20.
//

import ClockKit


final class ComplicationController: NSObject, CLKComplicationDataSource {
  
  private lazy var shortcutProvider = ShortcutComplicationProvider()
  private lazy var perkProvider = PerkComplicationProvider()
  private lazy var castleProvider = CastleComplicationProvider()
  
  // MARK: - Complication Configuration
  
  func getComplicationDescriptors(handler: @escaping ([CLKComplicationDescriptor]) -> Void) {
    let descriptors = [
      CLKComplicationDescriptor(identifier: "complication", displayName: "Castles",
                                supportedFamilies: [.graphicCorner, .graphicRectangular, .graphicExtraLarge])
      // Multiple complication support can be added here with more descriptors
    ]
    
    // Call the handler with the currently supported complication descriptors
    handler(descriptors)
  }
  
  func handleSharedComplicationDescriptors(_ complicationDescriptors: [CLKComplicationDescriptor]) {
    // Do any necessary work to support these newly shared complication descriptors
  }
  
  // MARK: - Timeline Configuration
  
  func getTimelineEndDate(for complication: CLKComplication, withHandler handler: @escaping (Date?) -> Void) {
    // Call the handler with the last entry date you can currently provide or nil if you can't support future timelines
    switch complication.family {
    case .graphicRectangular:
      handler(perkProvider.perkEndDate)
    default:
      handler(nil)
    }
  }
  
  func getPrivacyBehavior(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationPrivacyBehavior) -> Void) {
    // Call the handler with your desired behavior when the device is locked
    handler(.showOnLockScreen)
  }
  
  // MARK: - Timeline Population
  
  func getCurrentTimelineEntry(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimelineEntry?) -> Void) {
    // Call the handler with the current timeline entry
    switch complication.family {
    case .graphicCorner:
      handler(CLKComplicationTimelineEntry(date: Date(), complicationTemplate: shortcutProvider.getShortcutComplication()))
    case .graphicRectangular:
      handler(CLKComplicationTimelineEntry(date: Date(), complicationTemplate: perkProvider.getComplication()))
    case .graphicExtraLarge:
      handler(CLKComplicationTimelineEntry(date: Date(), complicationTemplate: castleProvider.getComplication()))
    default:
      handler(nil)
    }
  }
  
  func getTimelineEntries(for complication: CLKComplication, after date: Date, limit: Int, withHandler handler: @escaping ([CLKComplicationTimelineEntry]?) -> Void) {
    // Call the handler with the timeline entries after the given date
    switch complication.family {
    case .graphicRectangular:
      handler(perkProvider.getFutureEntries(after: date, limit: limit))
    default:
      handler(nil)
    }
  }
  
  // MARK: - Sample Templates
  
  func getLocalizableSampleTemplate(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTemplate?) -> Void) {
    // This method will be called once per supported complication, and the results will be cached
    switch complication.family {
    case .graphicCorner:
      handler(shortcutProvider.getShortcutComplication())
    case .graphicRectangular:
      handler(perkProvider.getSample())
    case .graphicExtraLarge:
      handler(castleProvider.getSample())
    default:
      handler(nil)
    }
  }
}
