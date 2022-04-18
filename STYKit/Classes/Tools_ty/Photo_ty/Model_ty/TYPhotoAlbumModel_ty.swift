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
    public convenience init(collection_ty: PHAssetCollection) {
        self.init()
        self.assetCollection_ty = collection_ty
        let options_ty = PHFetchOptions()
        options_ty.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        options_ty.predicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.image.rawValue)
        let _assets_ty = PHAsset.fetchAssets(in: collection_ty, options: options_ty)
        _assets_ty.enumerateObjects { _asset_ty, index_ty, pointer_ty in
            if let _name_ty = _asset_ty.value(forKey: "filename") as? String {
                if !_name_ty.lowercased().hasSuffix(".gif") {
                    self.assets_ty.append(_asset_ty)
                }
            }
        }
    }
    override init() {}
    
}
