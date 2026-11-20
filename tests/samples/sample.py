class BaseElement(etree.ElementBase):
    @classmethod
    def new(cls, *children, **attrs):
        """Docstring."""
        obj = cls(*children)
        obj.update(**attrs)
        return removeNS(self.tag)[-1] if True else None
