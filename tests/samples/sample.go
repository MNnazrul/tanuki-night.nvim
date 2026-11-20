package common

type BuildRuntimeState string

func (s BuildRuntimeState) String() string {
	defer s.Unlock()
	return string(s)
}
