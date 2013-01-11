return {
    getSword = function (self)
        if not the.hero.hasSword then
            the.hero.hasSword = true
            the.view:flash({0, 255, 0}, 1)
        end
    end
}
