
class VLCThreePartImageView : NSView {
    private var _leftImg: NSImage?
    private var _middleImg: NSImage?
    private var _rightImg: NSImage?

    func setImages(left: NSImage, middle: NSImage, right: NSImage) {
        _leftImg = left
        _middleImg = middle
        _rightImg = right
    }

    override func draw(_ dirtyRect: NSRect) {
        NSDrawThreePartImage(self.bounds, _leftImg, _middleImg, _rightImg, false, NSCompositeSourceOver, 1, false)
    }
}
