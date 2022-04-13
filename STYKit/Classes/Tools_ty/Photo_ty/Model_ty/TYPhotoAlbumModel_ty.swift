//
//  TYPhotoAlbumModel_ty.swift
//  STYKit
//
//  Created by apple on 2022/4/12.
//

import ObjectMapper
import Photos

public class TYPhotoAlbumModel_ty: NSObject {
    public var id_ty: Int = 0
    public var assets_ty  = [PHAsset]()
    public var assetCollection_ty: PHAssetCollection?
    public convenience init(collection: PHAssetCollection) {
        self.init()
        self.assetCollection_ty = collection
        let options = PHFetchOptions()
        options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        options.predicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.image.rawValue)
        let _assets = PHAsset.fetchAssets(in: collection, options: options)
        _assets.enumerateObjects { _asset, index, pointer in
            if let _name = _asset.value(forKey: "filename") as? String {
                if !_name.lowercased().hasSuffix(".gif") {
                    self.assets_ty.append(_asset)
                }
            }
        }
    }
    override init() {}
    
}
